//
//  Workspace.swift
//  Worky
//
//  Created by Kenneth Quintero on 30/05/22.
//

import Foundation

struct Workspace: Identifiable, Encodable {
    
    public var title: String
    public var emoji: String
    public var id: String
    public var url: URL
    
    init(title: String, emoji: String, url: URL) {
        
        self.title = title
        self.emoji = emoji
        self.id = UUID().uuidString
        self.url = url
    }
    
    init(title: String, emoji: String, container: URL) {
        
        self.title = title
        self.emoji = emoji
        self.id = UUID().uuidString
        self.url = container.appendingPathComponent("\(title)/")
    }

    init?(from json: [String: String]) {
        
        self.title = json["title"]!
        self.emoji = json["emoji"]!
        self.id = json["id"]!
        self.url = URL(string: json["url"]!)!
    }
    
    init(file: URL) throws {
        workspaceLog.info("Creating workspace from file path.")
        
        let data = FileManager.default.contents(atPath: file.path)
        let jsonRaw = try JSONSerialization.jsonObject(with: data!, options: [])
        
        workspaceLog.info("Parsing workspace json from serialized workspace.")
        let jsonParsed = jsonRaw as! [String : String]
        
        self.title = jsonParsed["title"]!
        self.emoji = jsonParsed["emoji"]!
        self.id = jsonParsed["id"]!
        self.url = URL(string: jsonParsed["url"]!)!
    }
}

extension Workspace {
   
    // MARK: - CreateDirectory
    static func createDirectory(for workspace: Workspace) {
        let fm = FileManager.default
        
        do {
            workspaceLog.info("Trying to create directory for workspace: \(workspace.title, privacy: .public)")
            try fm.createDirectory(
                at: workspace.url,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            workspaceLog.error("Could not create directory. Error: \(error.localizedDescription, privacy: .public)")
            fatalError("Could not create directory. Error \(error)")
        }
    }
    
    // MARK: - Serialize
    static func serialize(_ workspace: Workspace) {
        workspaceLog.info("Trying to serialize workspace: \(workspace.title, privacy: .public)")
        
        let jsonEncoder = JSONEncoder()
        
        workspaceLog.info("Trying to encode workspace: \(workspace.title, privacy: .public)")
        
        guard let jsonData = try? jsonEncoder.encode(workspace) else {
            workspaceLog.error("Could not encode workspace.")
            fatalError("Could not encode workspace.")
        }
        
        workspaceLog.info("Encoded workspace succesfully.")
        
        let fm = FileManager.default
        
        workspaceLog.info("Creating file for serialized workspace at: \(workspace.url.path).")
        
        fm.createFile(
            atPath: workspace.url.path+"/.worky.json",
            contents: jsonData,
            attributes: nil
        )
    }
}

extension Workspace {
    
    // MARK: - GetWorkspaces
    static func getWorkspaces() -> [Workspace] {
        var workspaces: [Workspace] = []
        
        workspaceLog.info("Trying to get contents of workspace container at $HOME/Documents/Worky.")
        
        guard let contents = try? FileManager.default.contentsOfDirectory(
             at: WorkyApp.container,
             includingPropertiesForKeys: nil,
             options: [
                 FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants,
                 FileManager.DirectoryEnumerationOptions.skipsHiddenFiles,
             ])
        else {
            workspaceLog.error("Could not get the contents.")
            return workspaces
        }
        
        for item in contents {
            workspaceLog.info("Handling contents of workpace directory at \(item.path).")
            
            guard let data = FileManager.default.contents(atPath: item.path + "/.worky.json") else {
                // Will try to read contents of current workspace directory always (it will be empty)
                workspaceLog.info("Could not read contents of file at: \(item.path)/.worky.json")
                continue
            }

            guard let jsonRaw = try? JSONSerialization.jsonObject(with: data, options: []) else {
                workspaceLog.error("Could not get json from data: \(data, privacy: .public)")
                continue
            }
             
            guard let jsonParsed = jsonRaw as? [String : String] else {
                // Error while trying to put jsonRaw in string interpolation
                workspaceLog.error("could not parse json as [String : String] : jsonRaw")
                continue
            }

            guard let workspace = Workspace.init(from: jsonParsed) else {
                workspaceLog.error("Could not create workspace from json: \(jsonParsed, privacy: .public)")
                continue
            }
             
            workspaces.append(workspace)
        }
        
        return workspaces
    }
    
    // MARK: - SelectWorkspace
    static func selectWorkspace(_ workspace: Workspace) -> Void {
        workspaceLog.info("Selecting workspace: \(workspace.title)")
        
        let fm = FileManager.default
        
        let desktopURL = fm
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Desktop")
        
        workspaceLog.info("Trying to get contents of desktop.")
        guard let desktopContents = try? fm.contentsOfDirectory(
            at: desktopURL,
            includingPropertiesForKeys: nil)
        else {
            workspaceLog.error("Could not get contents of desktop. Current workspace: \(WorkyApp.currentWorkspace != nil ? WorkyApp.currentWorkspace!.title : "nil")")
            return
        }
        
        var desktopIsAWorkspace = false;
        
        // use a for in
        workspaceLog.info("Checking wheter desktop is workspace or not.")
        desktopContents.forEach { URL in
            if URL.path.contains(".worky.json") {
                workspaceLog.info("Workspace found in desktop. Setting currentWorkspace.")
                desktopIsAWorkspace = true
                return
            }
        }
        
        if desktopIsAWorkspace {
            workspaceLog.info("Getting workspace dir url from current workspace at desktop.")
            
            // If desktop is a workspace then force unwrap
            guard let currentWorkspaceURL = WorkyApp.currentWorkspace?.url else {
                workspaceLog.error("Could not get url from current workspace. There isn't one.")
                fatalError("Could not get url from current workspace. There isn't one.")
            }
            
            workspaceLog.info("Current workspace url obtained succefully.")
            
            // many assumptions here!!!!
            for URL in desktopContents {
                workspaceLog.info("Looping through desktop contents to move them into their workspace directory.")
                
                // Move everyting except for the fucking .DS_Store file
                if !URL.path.contains(".DS_Store") {
                    do {
                        workspaceLog.info("Trying to move item at: \(URL.path) to \(currentWorkspaceURL.path).")
                        try fm.moveItem(
                            at: URL,
                            to: currentWorkspaceURL.appendingPathComponent(URL.lastPathComponent))
                    } catch {
                        workspaceLog.error("Could not move item to new location.")
                        fatalError("Could not move item at \(URL.path) to \(currentWorkspaceURL.path).")
                    }
                }
            }
        }

        workspaceLog.info("Trying to get contents of workspace directory at \(workspace.url.path)")
        guard let workspaceContents = try? fm.contentsOfDirectory(
            at: workspace.url,
            includingPropertiesForKeys: nil)
        else {
            workspaceLog.error("Could not get contents directory.")
            fatalError("Could not get contents of directory at \(workspace.url.path) contents that could be moved to desktop.")
        }
        
        workspaceLog.info("Looping through contents of workspace directory at \(workspace.url.path)")
        workspaceContents.forEach { URL in
            print(URL.path)
            if !URL.path.contains(".DS_Store") {
                do {
                    workspaceLog.info("Trying to move element at \(URL.path) to desktop.")
                    try fm.moveItem(at: URL, to: desktopURL.appendingPathComponent(URL.lastPathComponent))
                } catch {
                    workspaceLog.error("Could not move element to desktop.")
                    fatalError("Could not move element at \(URL.path) to desktop.")
                }
            }
        }
        
        workspaceLog.info("Setting current workspace to workspace selected: \(workspace.title).")
        WorkyApp.currentWorkspace = workspace
    }
    
    static func deleteWorkspace(_ workspace: Workspace) {
        
        let fm = FileManager.default
        
        // If there's a current workspace.
        if let currentWorkspace = WorkyApp.currentWorkspace {
            
            // If workspace to delete is the current one.
            if workspace.id == currentWorkspace.id {
                
                let desktopURL = fm
                    .homeDirectoryForCurrentUser
                    .appendingPathComponent("Desktop")
                
                
                // Then remove files in desktop and workspace dir in Documents/Worky.
                do {
                    let desktopContents = try fm.contentsOfDirectory(at: desktopURL, includingPropertiesForKeys: nil)
                    
                    for filePath in desktopContents {
                        try fm.removeItem(at: filePath)
                    }
                    try fm.removeItem(at: workspace.url)
                } catch {
                    print(error)
                }
                
                // Set current workspace to nil
                WorkyApp.currentWorkspace = nil
                
                return // There's no need to keep going.
            }
        }
        
        // If there's not a current workspace or the current one is not being deleted
        // then delete the given workspace.
        let workspaceDir = workspace.url
            
        do {
            try fm.removeItem(at: workspaceDir)
        } catch {
            print("Couldn't remove workspace: \(workspace.title)")
            print(error)
        }
    }
    
    static func getAllWorkspacesWithCurrent() -> [Workspace] {
        var workspaces = Workspace.getWorkspaces()
        if let currentWorkspace = WorkyApp.currentWorkspace {
            workspaces.append(currentWorkspace)
        }
        return workspaces
    }
}
