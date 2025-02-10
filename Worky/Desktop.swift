//
//  Desktop.swift
//  Worky
//
//  Created by Kenneth Quintero on 08/02/25.
//

import Foundation
import Cocoa

class Desktop {
    
    static let shared = Desktop()
    
    let directory = FileManager
        .default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("Desktop")
    
    var currentWorkspace: Workspace? {
        guard var workspace = try? Workspace(from: self.directory) else {
            return nil
        }
        
        let desktopContents = try! FileManager.default.contentsOfDirectory(
            at: self.directory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        
        workspace.itemCount = desktopContents.count
        return workspace
    }
    
    func getContents() throws -> [URL] {
        try FileManager.default.contentsOfDirectory(
            at: self.directory,
            includingPropertiesForKeys: nil
        )
    }
    
    func moveContents(to newLocation: URL) {
        do {
            for url in try self.getContents() {
                do {
                    try FileManager.default.moveItem(at: url, to: newLocation.appendingPathComponent(url.lastPathComponent))
                    
                } catch let error as NSError {
                    if error.code == NSFileWriteFileExistsError {
                        if (url.lastPathComponent == ".workspace.json") {
                            try! FileManager.default.removeItem(at: newLocation.appendingPathExtension("/\(url.lastPathComponent)"))
                            
                        } else {
                            let alert = NSAlert()
                            alert.messageText = "Trying to move current workspace contents into it's directory, but a file with the same name already exists inside: \(url.lastPathComponent)"
                            alert.runModal()
                        }
                    }
                }
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
