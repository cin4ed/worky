//
//  Workspace.swift
//  Worky
//
//  Created by Kenneth Quintero on 30/05/22.
//

import Foundation

struct Workspace: Identifiable, Encodable, Equatable {
    
    // Every time we instantiate a Workspace we'll make shure:
    //      - the container exists
    //      - the container has a directory for the workspace
    
    // TODO: Remove url init parameter
    // Supposing all workspaces will exists inside $HOME/Documents/Worky
    // we don't need to create a FileManager instance from the caller code
    // everytime, and so we could reduce the probability of creatinga bug.
    
    static public let fileName = ".worky.json"
    
    public var title: String
    public var emoji: String
    public var id: String
    public var url: URL
    
    init(title: String, emoji: String = "📦") {
        self.title = title
        self.emoji = emoji
        self.id = UUID().uuidString
        self.url = WorkyModel.containerURL.appendingPathComponent(title)
    }
    
    init?(directoryURL: URL) {
        let fm = FileManager.default
        
        var contentsOfDir: [URL]
        
        var title: String!
        var emoji: String!
        var id: String!
        var url: URL!
        
        do {
            contentsOfDir = try fm.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: nil
            )
        } catch {
            return nil
        }
        
        for fileURL in contentsOfDir {
            if fileURL.hasDirectoryPath { continue }
            if !fileURL.path.contains(Workspace.fileName) { continue }
            
            // A file with ".worky.json" in its path exists
            
            // Gettin the file data
            guard let fileData = fm.contents(atPath: fileURL.path) else { return nil }
            
            // Getting a json object from the data
            var json: Any
            
            do {
                json = try JSONSerialization.jsonObject(with: fileData)
            } catch {
                return nil
            }
            
            // Getting a dictionary from the json object
            guard let dict = json as? [String : String] else { return nil }
            
            // Getting the properties
            guard let _title = dict["title"] else { return nil }
            guard let _emoji = dict["emoji"] else { return nil }
            guard let _id = dict["id"] else { return nil }
            guard let stringURL = dict["url"] else { return nil }
            guard let _url = URL(string: stringURL) else { return nil }
            
            title = _title
            emoji = _emoji
            id = _id
            url = _url
        }
        
        // This needs to be outside a loop I think?
        // that's why the added complexity above
        self.title = title
        self.emoji = emoji
        self.id = id
        self.url = url
    }
    
    // MARK: getContents
    // Get contents only if it is not the current one
    func getContents() -> [URL] {
        self.createDirectoryIfNeeded()
        
        let fm = FileManager.default
        
        do {
            let workspaceContents = try fm.contentsOfDirectory(
                at: self.url,
                includingPropertiesForKeys: nil
            )
            
            return workspaceContents
        } catch {
            let errorMessage = """
            Could not get the contents of workspace.
                Workspace title: \(self.title)
                Specified location: \(self.url.path)
                Error: \(error.localizedDescription)
            """
            fatalError(errorMessage)
        }
    }
    
    // MARK: select
    func select() {
        // If currentWorkspace is the same do nothing
        // otherwise move current to its directory
        if let currentWorkspace = WorkyModel.currentWorkspace {
            if self == currentWorkspace { return }
            currentWorkspace.moveToItsDirectoryIfNeeded()
        }
        
        let fm = FileManager.default
        
        let desktopURL = fm
            .homeDirectoryForCurrentUser
            .appendingPathComponent("/Desktop")
        
        for fileURL in self.getContents() {
            if !fileURL.path.contains(".DS_Store") {
                do {
                    try fm.moveItem(
                        at: fileURL,
                        to: desktopURL.appendingPathComponent(fileURL.lastPathComponent)
                    )
                } catch {
                    let errorMessage = """
                    Could not move file from workspace to desktop.
                        Workspace title: \(self.title)File path: \(fileURL.path)
                        Destination path: \(desktopURL.appendingPathComponent(fileURL.lastPathComponent))
                        Error: \(error.localizedDescription)
                    """
                    fatalError(errorMessage)
                }
            }
        }
    }
    
    // MARK: delete
    func delete() {
        self.moveToItsDirectoryIfNeeded()
        
        do {
            try FileManager
                .default
                .trashItem(at: self.url, resultingItemURL: nil)
        } catch {
            let errorMessage = """
            Could not move workspace to trash.
                Workspace: \(self.title)
                Workspace path: \(self.url.path)
                Error: \(error.localizedDescription)
            """
            fatalError(errorMessage)
        }
    }
    
    // MARK: createDirectoryIfNeeded
    // Ensure that a directory for the workspace exists in $HOME/Documents/Worky
    func createDirectoryIfNeeded() {
        // Create the directory
        do {
            try FileManager
                .default
                .createDirectory(at: self.url, withIntermediateDirectories: true)
        } catch {
            let errorMessage = """
            Could not create directory for workspace.
                Workspace: \(self.title)
                Specified location: \(self.url.path)
                Error: \(error.localizedDescription)
            """
            fatalError(errorMessage)
        }
        
        // Place a json serialization file of the workspace inside the directory
        // if it isn't the current one (if there's one)
        if let currentWorkspace = WorkyModel.currentWorkspace {
            if self.title == currentWorkspace.title { return }
        }
        
        do {
            let jsonData = try JSONEncoder().encode(self)
            print(self.url.appendingPathComponent(Workspace.fileName).path)
            FileManager.default.createFile(
                atPath: self.url.appendingPathComponent(Workspace.fileName).path,
                contents: jsonData,
                attributes: nil
            )
        } catch {
            let errorMessage = """
        Could not create seriaization for workspace.
            Workspace: \(self.title)
            Specified location: \(self.url.appendingPathComponent(Workspace.fileName).path)
            Error: \(error.localizedDescription)
        """
            fatalError(errorMessage)
        }
    }
    
    // MARK: moveToItsDirectoryIfNeeded
    // If the workspace is the current one, it will the workspace contents in the
    // desktop into the workspace directory
    func moveToItsDirectoryIfNeeded() {
        self.createDirectoryIfNeeded()
        
        guard let currentWorkspace = WorkyModel.currentWorkspace else { return }
       
        if self == currentWorkspace {
            let fm = FileManager.default
            
            let desktopURL = fm
                .homeDirectoryForCurrentUser
                .appendingPathComponent("Desktop")
            
            // Trying to get the contents of the desktop
            let desktopContents: [URL]?
            
            do {
                desktopContents = try fm.contentsOfDirectory(
                    at: desktopURL,
                    includingPropertiesForKeys: nil
                )
            } catch {
                let errorMessage = """
                Could not get contents of desktop.
                    Specified location: \(desktopURL.path)
                    Error: \(error.localizedDescription)
                """
                fatalError(errorMessage)
            }
            
            // Move each file in the desktop to the workspace directory
            for fileUrl in desktopContents! {
                do {
                    try fm.moveItem(
                        at: fileUrl,
                        to: WorkyModel.containerURL
                    )
                } catch {
                    let errorMessage = """
                    Could not move file to its workspace directory.
                        File location: \(fileUrl.path)
                        Destination: \(WorkyModel.containerURL)
                        Error: \(error.localizedDescription)
                    """
                    fatalError(errorMessage)
                }
            }
        }
    }
    
    // TODO import directory as workspace
    
    // MARK: equatableFunction
    static func == (lhs: Workspace, rhs: Workspace) -> Bool {
        return lhs.id == rhs.id
    }
}
