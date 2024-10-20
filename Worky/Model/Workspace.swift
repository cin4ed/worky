//
//  Workspace.swift
//  Worky
//
//  Created by Kenneth Quintero on 30/05/22.
//

import Foundation

struct Workspace: Identifiable, Equatable, Encodable, Decodable {
    public var id = UUID()
    public var name: String
    public var emoji: String
    public var itemCount: Int
    public var url: URL
    
    init(name: String, emoji: String, itemCount: Int = 0, url: URL) {
        self.name = name
        self.emoji = emoji
        self.itemCount = itemCount
        self.url = url
    }
    
    init(name: String, emoji: String) {
        self.name = name
        self.emoji = emoji
        self.itemCount = 0
        self.url = URL(fileURLWithPath: "")
    }
    
    /// Creates a directory for the `Workspace` instance at the specified location if it does not already exist.
    ///
    /// The directory will be named after the workspace's `name` property and will be created inside the specified `directory` URL.
    /// If the directory already exists, no action is taken. If necessary, any intermediate directories in the path will also be created.
    ///
    /// - Parameter directory: The base directory where the workspace's directory should be created.
    /// - Returns: The URL of the created or existing directory.
    /// - Throws: An error if the directory could not be created.
    @discardableResult
    func createDirectory(at directory: URL) throws -> URL {
        let fileManager = FileManager.default
        let workspaceDirectory = directory.appendingPathComponent(name)
        
        // Create the directory if it does not exist
        try fileManager.createDirectory(at: workspaceDirectory, withIntermediateDirectories: true, attributes: nil)
        
        // Return the URL of the created or existing directory
        return workspaceDirectory
    }
    
    /// Saves the `Workspace` instance as a JSON file in the specified directory
    ///
    /// The file will be named `.[workspace.name].json`, making it a hidden file on macOS.
    /// If a file with the same name already exists, it will be overwritten.
    ///
    /// - Parameter directory: The directory where the JSON file should be saved.
    /// - Returns: The URL of the saved JSON file.
    /// - Throws: An error if encoding the `Workspace` to JSON or writing the file fails.
    @discardableResult
    func saveAsJSON(at directory: URL) throws -> URL {
        // Create a hidden file name using the workspace's name
        let jsonFileName = ".\(name).json"
        let jsonFilepath = directory.appendingPathComponent(jsonFileName)
        
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(self)
        
        // Write the JSON data to a file
        try jsonData.write(to: jsonFilepath, options: .atomic)
        
        return jsonFilepath
    }
    
    //    init?(directoryURL: URL) {
    //        let fm = FileManager.default
    //
    //        var contentsOfDir: [URL]
    //
    //        var title: String!
    //        var emoji: String!
    //        var id: String!
    //        var url: URL!
    //
    //        do {
    //            contentsOfDir = try fm.contentsOfDirectory(
    //                at: directoryURL,
    //                includingPropertiesForKeys: nil
    //            )
    //        } catch {
    //            return nil
    //        }
    //
    //        for fileURL in contentsOfDir {
    //            if fileURL.hasDirectoryPath { continue }
    //            if !fileURL.path.contains(Workspace.fileName) { continue }
    //
    //            // A file with ".worky.json" in its path exists
    //
    //            // Gettin the file data
    //            guard let fileData = fm.contents(atPath: fileURL.path) else { return nil }
    //
    //            // Getting a json object from the data
    //            var json: Any
    //
    //            do {
    //                json = try JSONSerialization.jsonObject(with: fileData)
    //            } catch {
    //                return nil
    //            }
    //
    //            // Getting a dictionary from the json object
    //            guard let dict = json as? [String : String] else { return nil }
    //
    //            // Getting the properties
    //            guard let _title = dict["title"] else { return nil }
    //            guard let _emoji = dict["emoji"] else { return nil }
    //            guard let _id = dict["id"] else { return nil }
    //            guard let stringURL = dict["url"] else { return nil }
    //            guard let _url = URL(string: stringURL) else { return nil }
    //
    //            title = _title
    //            emoji = _emoji
    //            id = _id
    //            url = _url
    //        }
    //
    //        // hacky fix
    //        if title == nil { return nil }
    //
    //        // This needs to be outside a loop I think?
    //        // that's why the added complexity above
    //        self.title = title
    //        self.emoji = emoji
    //        self.url = url
    //    }
    //
    //    // MARK: getContents
    //    // Get contents only if it is not the current one
    //    func getContents() -> [URL] {
    //        self.createDirectoryIfNeeded()
    //
    //        let fm = FileManager.default
    //
    //        do {
    //            let workspaceContents = try fm.contentsOfDirectory(
    //                at: self.url,
    //                includingPropertiesForKeys: nil
    //            )
    //
    //            return workspaceContents
    //        } catch {
    //            let errorMessage = """
    //            Could not get the contents of workspace.
    //                Workspace title: \(self.title)
    //                Specified location: \(self.url.path)
    //                Error: \(error.localizedDescription)
    //            """
    //            fatalError(errorMessage)
    //        }
    //    }
    //
    //    // MARK: select
    //    func select() {
    //        // If currentWorkspace is the same do nothing
    //        // otherwise move current to its directory
    //        if let currentWorkspace = WorkyModel.currentWorkspace {
    //            if self == currentWorkspace { return }
    //            currentWorkspace.moveToItsDirectoryIfNeeded()
    //        }
    //
    //        let fm = FileManager.default
    //
    //        let desktopURL = fm
    //            .homeDirectoryForCurrentUser
    //            .appendingPathComponent("/Desktop")
    //
    //        for fileURL in self.getContents() {
    //            if !fileURL.path.contains(".DS_Store") {
    //                do {
    //                    try fm.moveItem(
    //                        at: fileURL,
    //                        to: desktopURL.appendingPathComponent(fileURL.lastPathComponent)
    //                    )
    //                } catch {
    //                    let errorMessage = """
    //                    Could not move file from workspace to desktop.
    //                        Workspace title: \(self.title)File path: \(fileURL.path)
    //                        Destination path: \(desktopURL.appendingPathComponent(fileURL.lastPathComponent))
    //                        Error: \(error.localizedDescription)
    //                    """
    //                    fatalError(errorMessage)
    //                }
    //            }
    //        }
    //    }
    //
    //    // MARK: delete
    //    func delete() {
    //        self.moveToItsDirectoryIfNeeded()
    //
    //        do {
    //            try FileManager
    //                .default
    //                .trashItem(at: self.url, resultingItemURL: nil)
    //        } catch {
    //            let errorMessage = """
    //            Could not move workspace to trash.
    //                Workspace: \(self.title)
    //                Workspace path: \(self.url.path)
    //                Error: \(error.localizedDescription)
    //            """
    //            fatalError(errorMessage)
    //        }
    //    }
    //
    
    //
    //    // MARK: moveToItsDirectoryIfNeeded
    //    // If the workspace is the current one, it will put the desktop's contents
    //    // into the workspace directory
    //    func moveToItsDirectoryIfNeeded() {
    //        self.createDirectoryIfNeeded()
    //
    //        guard let currentWorkspace = WorkyModel.currentWorkspace else { return }
    //
    //        if self.title == currentWorkspace.title {
    //            let fm = FileManager.default
    //
    //            let desktopURL = fm
    //                .homeDirectoryForCurrentUser
    //                .appendingPathComponent("Desktop")
    //
    //            // Trying to get the contents of the desktop
    //            let desktopContents: [URL]?
    //
    //            do {
    //                desktopContents = try fm.contentsOfDirectory(
    //                    at: desktopURL,
    //                    includingPropertiesForKeys: nil
    //                )
    //            } catch {
    //                let errorMessage = """
    //                Could not get contents of desktop.
    //                    Specified location: \(desktopURL.path)
    //                    Error: \(error.localizedDescription)
    //                """
    //                fatalError(errorMessage)
    //            }
    //
    //            // Move each file in the desktop to the workspace directory
    //            for fileURL in desktopContents! {
    //                if fileURL.path.contains(".DS_Store") { continue }
    //                if fileURL.path.contains(".worky.json") {
    //                    do {
    //                        try fm.moveItem(
    //                            at: fileURL,
    //                            to: self.url.appendingPathComponent(fileURL.lastPathComponent)
    //                        )
    //                    } catch {
    //                        try? fm.trashItem(at: fileURL, resultingItemURL: nil)
    //                    }
    //                } else {
    //                    do {
    //                        try fm.moveItem(
    //                            at: fileURL,
    //                            to: self.url.appendingPathComponent(fileURL.lastPathComponent)
    //                        )
    //                    } catch {
    //                        let errorMessage = """
    //                    Could not move file to its workspace directory.
    //                        File location: \(fileURL.path)
    //                        Destination: \(self.url.appendingPathComponent(fileURL.lastPathComponent).path)
    //                        Error: \(error.localizedDescription)
    //                    """
    //                        fatalError(errorMessage)
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    //    // TODO import directory as workspace
    //
    //    // MARK: equatableFunction
    //    static func == (lhs: Workspace, rhs: Workspace) -> Bool {
    //        return lhs.id == rhs.id
    //    }
}
