//
//  Workspace.swift
//  Worky
//
//  Created by Kenneth Quintero on 16/01/25.
//

import Foundation

struct Workspace: Identifiable, Equatable, Encodable, Decodable {
    public var id = UUID()
    public var name: String
    public var emoji: String
    public var itemCount: Int = 0
    public var url: URL = FileManager.default.temporaryDirectory
    
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
        let workspaceDirectoryUrl = directory.appendingPathComponent(name)
        
        try FileManager.default.createDirectory(
            at: workspaceDirectoryUrl,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        return workspaceDirectoryUrl
    }
    
    /// Saves the `Workspace` instance as a JSON file in the specified directory
    ///
    /// The file will be named `.workspace.json`, making it a hidden file on macOS.
    /// If a file with the same name already exists, it will be overwritten.
    ///
    /// - Parameter directory: The directory where the JSON file should be saved.
    /// - Returns: The URL of the saved JSON file.
    /// - Throws: An error if encoding the `Workspace` to JSON or writing the file fails.
    @discardableResult
    func saveAsJSON(at directory: URL) throws -> URL {
        let jsonFileName = ".workspace.json"
        let filePath = directory.appendingPathComponent(jsonFileName)
        
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(self)
        
        // Write the JSON data to a file
        try jsonData.write(to: filePath, options: .atomic)
        
        return filePath
    }
}


extension Workspace {
    /// Initializes a `Workspace` instance by decoding it from the provided JSON data.
    ///
    /// This initializer attempts to decode a `Workspace` instance from the given `Data` object
    /// using a `JSONDecoder`. If the data is not valid JSON or does not conform to the expected
    /// structure of a `Workspace`, an error is thrown.
    ///
    /// - Parameter data: The JSON data representing a `Workspace` instance.
    /// - Throws: An error if decoding the data fails, such as `DecodingError` or `JSONDecoder`-related issues.
    /// - Returns: A `Workspace` instance if decoding is successful; otherwise, `nil`.
    ///
    /// # Example
    /// ```swift
    /// let jsonData = """
    /// {
    ///     "id": "3b2ac053-6c53-4c68-b6cc-728e78871854",
    ///     "name": "My Workspace",
    ///     "emoji": "🚀",
    ///     "itemCount": 5
    ///     "url": "file:///Users/johndoe/.worky/My%20Workspace"
    /// }
    /// """.data(using: .utf8)!
    ///
    /// do {
    ///     if let workspace = try Workspace(from: jsonData) {
    ///         print("Workspace loaded: \(workspace)")
    ///     } else {
    ///         print("Failed to decode workspace.")
    ///     }
    /// } catch {
    ///     print("Error decoding workspace: \(error)")
    /// }
    init?(from data: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(Workspace.self, from: data)
    }
}
