//
//  MenuDelegate.swift
//  Worky
//
//  Created by Kenneth Quintero on 19/11/22.
//

import Foundation
import AppKit

class MenuDelegate: NSObject, NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        // Clean the displaying menu
        menu.removeAllItems()
        
        WorkyModel.createContainerIfNeeded()
        
        let systemState = WorkyModel.getStateOfSystem()
        
        var thereAreWorkspaces: Bool
        var currentWorkspaceExists: Bool
        
        switch systemState {
        case ._000:
            thereAreWorkspaces = false
            currentWorkspaceExists = false
        case ._001:
            WorkyModel.currentWorkspace!.createDirectoryIfNeeded()
            thereAreWorkspaces = true
            currentWorkspaceExists = true
        case ._010:
            WorkyModel.updateEveryWorkspaceIfNeeded()
            thereAreWorkspaces = true
            currentWorkspaceExists = false
        case ._011:
            WorkyModel.updateEveryWorkspaceIfNeeded()
            WorkyModel.currentWorkspace!.createDirectoryIfNeeded()
            thereAreWorkspaces = true
            currentWorkspaceExists = true
        case ._100:
            WorkyModel.makeEveryDirectoryInContainerAWorkspace()
            thereAreWorkspaces = true
            currentWorkspaceExists = false
        case ._101:
            WorkyModel.currentWorkspace!.createDirectoryIfNeeded()
            WorkyModel.makeEveryDirectoryInContainerAWorkspaceExceptForCurrent()
            thereAreWorkspaces = true
            currentWorkspaceExists = true
        case ._110:
            WorkyModel.makeEveryDirectoryInContainerAWorkspace()
            WorkyModel.updateEveryWorkspaceIfNeeded()
            thereAreWorkspaces = true
            currentWorkspaceExists = false
        case ._111:
            WorkyModel.makeEveryDirectoryInContainerAWorkspaceExceptForCurrent()
            WorkyModel.updateEveryWorkspaceIfNeeded()
            thereAreWorkspaces = true
            currentWorkspaceExists = true
        }

        // Add version number
        var workyVersion: String?
        
        if let bundleVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  {
            if let version = bundleVersionString as? String {
                workyVersion = version
            }
        }
        
        menu.addItem(
            withTitle: "Worky \(workyVersion ?? "")",
            action: nil,
            keyEquivalent: ""
        )
        
        // Add new workspace
        menu.addItem(
            withTitle: "Add new workspace",
            action: #selector(addNewWorkspace),
            keyEquivalent: "a"
        ).target = self
    
        // Add import as workspace
        menu.addItem(
            withTitle: "Import as workspace",
            action: #selector(importAsWorkspace),
            keyEquivalent: ""
        ).target = self
        
        menu.addItem(.separator())
        
        // Show workspaces not selected if there are
        if thereAreWorkspaces {
            let workspaces = WorkyModel.workspaces
            
            menu.addItem(
                withTitle: "Choose a workspace",
                action: nil,
                keyEquivalent: ""
            )
            
            for workspace in workspaces {
                let item = menu.addItem(
                    withTitle: "\(workspace.emoji) \(workspace.title)",
                    action: #selector(chooseWorkspace),
                    keyEquivalent: ""
                )
                item.representedObject = workspace
                item.target = self
            }
        }
        
        if currentWorkspaceExists {
            let workspace = WorkyModel.currentWorkspace!
            
            let menuItem = menu.addItem(
                withTitle: "\(workspace.emoji) \(workspace.title)",
                action: nil,
                keyEquivalent: "")
            
            menuItem.isEnabled = false
            
            menu.addItem(
                withTitle: "Empty",
                action: #selector(emptyDesktop),
                keyEquivalent: "H"
            ).target = self
        }
        
        if !thereAreWorkspaces {
            menu.addItem(
                withTitle: "No workspaces available",
                action: nil,
                keyEquivalent: ""
            )
        }
            
        menu.addItem(.separator())
            
        // Add preferences
        menu.addItem(
            withTitle: "Preferences",
            action: #selector(showPreferencesWindow),
            keyEquivalent: ""
        ).target = self
        
        // Add Quit
        menu.addItem(
            withTitle: "Quit Worky",
            action: #selector(quitApp),
            keyEquivalent: "q"
        ).target = self
    }
    
    // MARK: Create workspace
    @objc func addNewWorkspace() {
        CreateWorkspaceWindow.shared.bringToFront()
    }
    
    // MARK: Import workspace
    @objc func importAsWorkspace() {
        let panel = NSOpenPanel()
        panel.canCreateDirectories = true
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        
        let response = panel.runModal()
        
        guard let importURL = response == .OK ? panel.url : nil else {
            return
        }
        
        let fm = FileManager.default
        
        // Stop if there's another directory in the container with the same
        let directoryName = importURL.lastPathComponent
        let matchInContainer = WorkyModel
            .containerURL
            .appendingPathComponent(directoryName)
            .path
        
        if fm.fileExists(atPath: matchInContainer) {
            let alert = NSAlert()
            alert.icon = NSImage(named: "AppIcon")
            alert.messageText = "A directory with the same name already exists in /Documents/Worky, try removing it."
            alert.runModal()
        }
        
        // Move directory into container
        do {
            try fm.moveItem(
                at: importURL,
                to: WorkyModel
                    .containerURL
                    .appendingPathComponent(importURL.lastPathComponent)
            )
        } catch {
            let errorMessage = """
            Could not move imported directory to container.
                Imported directory path: \(importURL.path)
                Destination url: \(WorkyModel.containerURL.appendingPathComponent(importURL.lastPathComponent))
                Error: \(error.localizedDescription)
            """
            fatalError(errorMessage)
        }
        
        let newWorkspace = Workspace(
            title: importURL.lastPathComponent,
            emoji: "📦"
        )
        
        newWorkspace.createDirectoryIfNeeded()
    }

    // MARK: Choose workspace
    @objc func chooseWorkspace(sender: NSMenuItem) {
        let workspace = sender.representedObject as! Workspace;
        workspace.select()
    }
    
    // MARK: Empty desktop
    @objc func emptyDesktop() {
//        Workspace.removeWorkspaceFromDesktop()
    }
   
    // MARK: Show preferences window
    @objc func showPreferencesWindow(sender: NSMenuItem) {
        ManageWindow.shared.bringToFront()
    }
    
    // MARK: Quit appplication
    @objc func quitApp() {
        NSApp.terminate(self)
    }
}
