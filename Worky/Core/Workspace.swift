//  Workspace.swift
//  Worky
//
//  Created by Kenneth Quintero on 16/01/25.
//

import Foundation
import Cocoa

enum WorkspaceError: Error {
    case decodingFailed
}

struct Workspace: Identifiable, Equatable, Encodable, Decodable {
    
    public var id = UUID()
    public var name: String
    public var emoji = "📦"
    public var itemCount: Int = 0
    public var directory: URL? = nil


    @discardableResult
    func createDirectory(at location: URL) throws -> URL {
        let directory = location.appendingPathComponent(name)
        
        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        return directory
    }
    
    @discardableResult
    func saveAsJSON(at directory: URL) throws -> URL {
        let jsonFileName = ".workspace.json"
        let filePath = directory.appendingPathComponent(jsonFileName)
        
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(self)
        
        try jsonData.write(to: filePath, options: .atomic)
        
        return filePath
    }
    
    func moveContents(to newLocation: URL) throws {
        let contents = try FileManager.default.contentsOfDirectory(
            at: directory!,
            includingPropertiesForKeys: nil
        )

        for url in contents {
            try FileManager.default.moveItem(at: url, to: newLocation.appendingPathComponent(url.lastPathComponent))
        }
    }

    mutating func renameDirectory(to newName: String, in parentDirectory: URL) throws {
        guard let currentDirectory = self.directory else { return }
        let newDirectory = parentDirectory.appendingPathComponent(newName)
        if currentDirectory != newDirectory {
            try FileManager.default.moveItem(at: currentDirectory, to: newDirectory)
            self.directory = newDirectory
        }
    }
}

extension Workspace {
    
    init?(from data: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(Workspace.self, from: data)
    }
    
    init?(from directory: URL) throws {
        guard let configFile = WorkspaceHelper.findConfigurationFile(in: directory) else { return nil }
        let data = try Data(contentsOf: configFile)
        self = try Workspace(from: data) ?? { throw WorkspaceError.decodingFailed }()
    }
}

// MARK: - WorkspaceHelper

enum WorkspaceHelperError: Error {
    case desktopDirectoryNotFound
}

final class WorkspaceHelper {
    
    static func findConfigurationFile(in directoryURL: URL) -> URL? {
        return FileManager.default.findFile(
            named: ".workspace.json",
            in: directoryURL
        )
    }
    
    static func fromDesktop() throws -> Workspace? {
        guard let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first else {
            throw WorkspaceHelperError.desktopDirectoryNotFound
        }
        return try Workspace(from: desktopURL)
    }
}
