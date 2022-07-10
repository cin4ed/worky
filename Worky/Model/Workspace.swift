//
//  Workspace.swift
//  Worky
//
//  Created by Kenneth Quintero on 30/05/22.
//

import Foundation

struct Workspace: Identifiable, Encodable {
    
    public var title: String
    public var id: String
    public var url: URL
    
    init(title: String, url: URL) {
        
        self.title = title
        self.id = UUID().uuidString
        self.url = url
    }
    
    init(title: String, container: URL) {
        
        self.title = title
        self.id = UUID().uuidString
        self.url = container.appendingPathComponent("\(title)/")
    }

    init?(from json: [String: String]) {
        
        self.title = json["title"]!
        self.id = json["id"]!
        self.url = URL(string: json["url"]!)!
    }
    
    init(file: URL) throws {
        
        let data = FileManager.default.contents(atPath: file.path)
        let jsonRaw = try JSONSerialization.jsonObject(with: data!, options: [])
        let jsonParsed = jsonRaw as! [String : String]
        
        self.title = jsonParsed["title"]!
        self.id = jsonParsed["id"]!
        self.url = URL(string: jsonParsed["url"]!)!
    }
}

extension Workspace {
    
    static func createDirectory(for workspace: Workspace) {
        let fm = FileManager.default
        
        try! fm.createDirectory(
            at: workspace.url,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    static func serialize(_ workspace: Workspace) {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(workspace)
        
        let fm = FileManager.default
        
        fm.createFile(
            atPath: workspace.url.path+"/.worky.json",
            contents: jsonData,
            attributes: nil
        )
    }
}

extension Workspace {
    
    static func getWorkspaces() -> [Workspace] {
        var workspaces: [Workspace] = []
        
        let contents = try! FileManager.default.contentsOfDirectory(
             at: WorkyApp.container,
             includingPropertiesForKeys: nil,
             options: [
                 FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants,
                 FileManager.DirectoryEnumerationOptions.skipsHiddenFiles,
             ])
        
        for item in contents {
             guard let data = FileManager.default.contents(atPath: item.path + "/.worky.json") else {
                 print("Couldn't read the contents of file: \(item.path)/.worky.json")
                 continue
             }

             guard let jsonRaw = try? JSONSerialization.jsonObject(with: data, options: []) else {
                 print("Coulnd't get json from data: \(data)")
                 continue
             }
             
             guard let jsonParsed = jsonRaw as? [String : String] else {
                 print("Couldn't parse json as [String : String]: \(jsonRaw)")
                 continue
             }

             guard let workspace = Workspace.init(from: jsonParsed) else {
                 print("Couldn't create workspace from json: \(jsonParsed)")
                 continue
             }
             
             workspaces.append(workspace)
        }
        
        return workspaces
    }
    
    static func selectWorkspace(_ workspace: Workspace) -> Void {
        
        let fm = FileManager.default
        
        let desktopURL = fm
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Desktop")
        
        guard let desktopContents = try? fm.contentsOfDirectory(
            at: desktopURL,
            includingPropertiesForKeys: nil) else {
            print("Couldn't get contents of \(desktopURL.path)")
            return
        }
        
        var desktopIsAWorkspace = false;
        
        // use a for in
        desktopContents.forEach { URL in
            if URL.path.contains(".worky.json") {
                desktopIsAWorkspace = true
                return
            }
        }
        
        if desktopIsAWorkspace {
            
            let currentWorkspaceURL = WorkyApp.currentWorkspace.url
            
            // many assumptions here!!!!
            for URL in desktopContents {
                try! fm.moveItem(
                    at: URL,
                    to: currentWorkspaceURL.appendingPathComponent(URL.lastPathComponent))
            }
        }

        let workspaceContents = try! fm.contentsOfDirectory(
            at: workspace.url,
            includingPropertiesForKeys: nil)
        
        workspaceContents.forEach { URL in
            print(URL.path)
            try! fm.moveItem(at: URL, to: desktopURL.appendingPathComponent(URL.lastPathComponent))
        }
        
        WorkyApp.currentWorkspace = workspace
    }
}
