//
//  Container.swift
//  Worky
//
//  Created by Kenneth Quintero on 07/02/25.
//

import Foundation

class Container {
    
    static let shared = Container()

    let directory = FileManager
        .default
        .homeDirectoryForCurrentUser
        .appendingPathComponent(".worky")
    
    func create() {
        do {
            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            fatalError("""
            Could not create container directory.
                Specified location: \(directory.path)
                Error: : \(error.localizedDescription)
            """)
        }
    }
    
    func getAvailableWorkspaces() -> [Workspace] {
        var workspaces: [Workspace] = []
        
        for url in getContents() {
            // Check if the file is a directory
            var isDirectory: ObjCBool = false
            FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)

            if isDirectory.boolValue {
                if var workspace = try? Workspace(from: url) {
                    workspace.itemCount = try! FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).count
                    workspaces.append(workspace)
                }
            }

        }
        
        return workspaces
    }

    func getContents() -> [URL] {
        create()
        return try! FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
    }
    
    func directoryExists(_ fileName: String) -> Bool {
        return FileManager.default.fileExists(atPath: directory.appendingPathComponent(fileName).path)
    }

    func directoryExists(_ url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
}
