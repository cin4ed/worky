//
//  WorkyModel.swift
//  Worky
//
//  Created by Kenneth Quintero on 04/08/22.
//

import Foundation

class WorkyModel {
    static let containerURL = FileManager
        .default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("Documents/Worky")
    
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
    
    static func makeEveryDirectoryInContainerAWorkspace() {
        let fm = FileManager.default
        
        let contentsOfContainer = try! fm.contentsOfDirectory(
            at: WorkyModel.containerURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        
        for url in contentsOfContainer {
            // If the url is not a directory skip it
            if !url.hasDirectoryPath { continue }
            
            // If directory is a workspace
            if Workspace(directoryURL: url) != nil {
                continue
            }
        
            // If it's not
            let newWorkspace = Workspace(title: url.lastPathComponent)
            newWorkspace.createDirectoryIfNeeded()
        }
    }
    
    static func updateEveryWorkspaceIfNeeded() -> Void {
        let fm = FileManager.default
        
        let contentsOfContainer = try! fm.contentsOfDirectory(
            at: WorkyModel.containerURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        
        for url in contentsOfContainer {
            // If the url is not a directory skip it
            if !url.hasDirectoryPath { continue }

            // If directory is a workspace
            if var workspace = Workspace(directoryURL: url) {
                // Update it to match directory title
                if workspace.title != url.lastPathComponent {
                    workspace.title = url.lastPathComponent
                    workspace.createDirectoryIfNeeded()
                }
                return
            }
        }
    }
    
    static func createContainerIfNeeded() -> Void {
        // Won't throw an error because withIntermediateDirectories
        // is set to true.
        try! FileManager.default.createDirectory(
            at: Self.containerURL,
            withIntermediateDirectories: true
        )
    }
    
    static func getStateOfSystem() -> SystemState {
//
//         The following is a simply data structure to represent the system state:
//         +---+-------------------+
//         | x | Directories       |
//         +---+-------------------+
//         | y | Workspaces        | -->
//         +---+-------------------+
//         | z | Current Workspace |
//         +---+-------------------+
//
        let x = Self.directoriesExists()
        let y = Self.workspacesExists()
        let z = Self.currentWorkspaceExists()
        
        if !x && !y && !z {
            return SystemState._000
        }
        
        if !x && !y && z {
            return SystemState._001
        }
        
        if !x && y && !z {
            return SystemState._010
        }
        
        if !x && y && z {
            return SystemState._011
        }
        
        if x && !y && !z {
            return SystemState._100
        }
        
        if x && !y && z {
            return SystemState._101
        }
        
        if x && y && !z {
            return SystemState._110
        }
        
        if x && y && z {
            return SystemState._111
        }
    }
    
    static func directoriesExists() -> Bool {
        let containerContents = try! FileManager
            .default
            .contentsOfDirectory(at: Self.containerURL, includingPropertiesForKeys: nil)
        
        for fileURL in containerContents {
            if fileURL.hasDirectoryPath && Workspace(directoryURL: fileURL) == nil {
                return true
            }
        }
        
        return false
    }
    
    static func workspacesExists() -> Bool {
        let containerContents = try! FileManager
            .default
            .contentsOfDirectory(at: Self.containerURL, includingPropertiesForKeys: nil)
        
        for fileURL in containerContents {
            if fileURL.hasDirectoryPath && Workspace(directoryURL: fileURL) != nil {
                return true
            }
        }
        
        return false
    }
    
    static func currentWorkspaceExists() -> Bool {
        let desktopURL = FileManager
            .default
            .homeDirectoryForCurrentUser
            .appendingPathComponent("/Desktop")
        
        if Workspace(directoryURL: desktopURL) == nil {
            return false
        }
        
        return true
    }
}
