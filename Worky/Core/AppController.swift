//
//  AppController.swift
//  Worky
//
//  Created by Kenneth Quintero on 11/02/25.
//

import Foundation
import Cocoa

class AppController {
    
    let container: Container
    let desktop: Desktop
    var onChoosedWorkspaceCallbacks: [() -> Void] = []
    
    init(container: Container, desktop: Desktop) {
        self.container = container
        self.desktop = desktop
    }
    
    var currentWorkspace: Workspace? {
        return desktop.currentWorkspace
    }
    
    var availableWorkspaces: [Workspace] {
        return container.getAvailableWorkspaces()
    }
    
    var containerContents: [URL] {
        return container.getContents()
    }
    
    func onChoosedWorkspace(_ callback: @escaping () -> Void) {
        onChoosedWorkspaceCallbacks.append(callback)
    }
    
    
    
    // for every directory in container that is not a workspace or the directory
    // name does not match workspace name do:
    func makeEveryDirectoryInContainerAWorkspaceExceptForCurrent() {
        for url in containerContents {
            // If it's not a directory skip it
            guard FileManager.default.isDirectory(url) else {
                continue
            }
            
            // If directory is not a workspace then convert it
            guard var workspace = try? Workspace(from: url) else {
                
                // If the directory has the same name as the current workspace, then continue
                guard currentWorkspace?.name != url.lastPathComponent else  {
                    continue
                }
                
                var newWorkspace = Workspace(name: url.lastPathComponent)
                newWorkspace.directory = url
                try! newWorkspace.saveAsJSON(at: url)
                
                continue
            }
            
            // Lastly if directory is a workspace but, the workspace name doesn't
            // match the directory one, then update workspace name to match directory
            if workspace.name != url.lastPathComponent {
                workspace.name = url.lastPathComponent
                workspace.directory = url
                try! workspace.saveAsJSON(at: url)
            }
        }
    }
    
    private func presentWorkspaceExistsAlert() {
        let alert = NSAlert()
        alert.messageText = "A workspace with the same name already exists"
        alert.runModal()
    }
    
    func createWorkspace(name: String, emoji: String) {
        let workspace = Workspace(name: name, emoji: emoji)
        
        if container.directoryExists(workspace.name) {
            presentWorkspaceExistsAlert()
            return
        }
        
        chooseWorkspace(workspace)
    }
    
    func chooseWorkspace(_ workspace: Workspace) {
        
        // If the workspace is already the current workspace, do nothing
        if desktop.currentWorkspace == workspace {
            return
        }
        
        var mutableWorkspace = workspace // Create a mutable copy
        
        if mutableWorkspace.directory == nil || !container.directoryExists(mutableWorkspace.directory!) {
            do {
                mutableWorkspace.directory = try mutableWorkspace.createDirectory(at: container.directory)
                try mutableWorkspace.saveAsJSON(at: mutableWorkspace.directory!)
            } catch {
                // Handle the error, e.g., show an alert
                print("Error creating or saving workspace: \(error)")
                return // Exit early if we can't create the directory.
            }
        }
        
        if var currentWorkspace = desktop.currentWorkspace {
            if !container.directoryExists(currentWorkspace.directory!) {
                do {
                    currentWorkspace.directory = try currentWorkspace.createDirectory(at: container.directory)
                } catch{
                    // Handle the error, e.g., show an alert
                    print("Error creating current workspace directory: \(error)")
                }
            }
            desktop.moveContents(to: currentWorkspace.directory!)
        }
        
        do {
            try mutableWorkspace.moveContents(to: desktop.directory)
        } catch {
            // Handle the error
            print("Error moving contents to desktop: \(error)")
        }
        
        for cb in onChoosedWorkspaceCallbacks {
            cb()
        }
    }
}
