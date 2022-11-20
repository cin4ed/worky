//
//  WorkyModel.swift
//  Worky
//
//  Created by Kenneth Quintero on 04/08/22.
//

import Foundation

class WorkyModel {
    // MARK: - Container Logic
    // The location of the container must be $HOME/Documents/Worky
    static var containerURL: URL {
        let url = FileManager
            .default
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Documents/Worky")
        
        let fm = FileManager.default
        
        // Created if needed
        do {
            try fm.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            let errorMessage = """
            Could not create workspace container.
                Specified location: \(url.path)
                Error: \(error.localizedDescription)
            """
            fatalError(errorMessage)
        }
        
        return url
    }
    
    // MARK: - Workspaces Logic
    static var workspaces: [Workspace] {
        // Create workspace container if needed
        // Make every directory inside the container a workspace
        // Update every json.title to match directory name
        Self.makeEveryDirectoryInContainerAWorkspace()

        var workspaces: [Workspace] = []

        let fm = FileManager.default
        
        let contentsOfContainer: [URL]?
        
        do {
            contentsOfContainer = try fm.contentsOfDirectory(
                at: containerURL,
                includingPropertiesForKeys: nil,
                options: [
                    FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants,
                    FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
                ]
            )
        } catch {
            let errorMessage = """
            Could not get contents of container.
                Specified location: \(containerURL.path)
                Error: \(error.localizedDescription)
            """
            fatalError(errorMessage)
        }
        
        // With the container contents we now instantiate every workspace
        for fileURL in contentsOfContainer! {
            if fileURL.hasDirectoryPath {
                workspaces.append(Workspace(directoryURL: fileURL)!)
            }
        }
        
        return workspaces
    }
    
    
    // MARK: - Current Workspace Logic
    static var currentWorkspace: Workspace? {
        // First try to see if there's a workspace in the desktop
        let desktopURL = FileManager
            .default
            .homeDirectoryForCurrentUser
            .appendingPathComponent("/Desktop")
        
        if let workspace = Workspace(directoryURL: desktopURL) {
            // If it is return it
            return workspace
        } else {
            // Else return nil
            return nil
        }
    }
    
    // MARK: - makeEveryDirectoryInContainerAWorkspace
    // This big boy right here do the following:
    //      - creates worky container if needed
    //      - make every directory in the container a workspace if needed
    //      - update every .worky.json title to match directory name if needed
    static func makeEveryDirectoryInContainerAWorkspace() {
        let fm = FileManager.default
        
        // If we get WorkyModel.containerURL, then is ensured it will exists
        let contentsOfContainer = try! fm.contentsOfDirectory(
            at: WorkyModel.containerURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )
        
        for url in contentsOfContainer {
            // If the url is not a directory skip it
            if !url.hasDirectoryPath { continue }
            
            // Already is a workspace
            if var workspace = Workspace(directoryURL: url) {
                // Update it to match directory title
                if workspace.title != url.lastPathComponent {
                    workspace.title = url.lastPathComponent
                    workspace.createDirectoryIfNeeded()
                }
                return
            }
        
            // It's not a workspace
            let newWorkspace = Workspace(title: url.lastPathComponent)
            newWorkspace.createDirectoryIfNeeded()
        }
    }
}
