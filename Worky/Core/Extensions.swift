//
//  Extensions.swift
//  Worky
//
//  Created by Kenneth Quintero on 01/02/25.
//

import Foundation

extension FileManager {
    /// Finds a file with the specified name in the given directory.
    ///
    /// - Parameters:
    ///   - fileName: The name of the file to find.
    ///   - directory: The URL of the directory in which to search.
    ///   - recursively: Whether to search subdirectories recursively. Defaults to `false`.
    /// - Returns: The URL of the file if found; otherwise, `nil`.
    func findFile(named fileName: String, in directory: URL, recursively: Bool = false) -> URL? {
        if recursively {
            // Use an enumerator to search through subdirectories.
            guard let enumerator = self.enumerator(at: directory, includingPropertiesForKeys: nil) else {
                return nil
            }
            
            for case let fileURL as URL in enumerator {
                if fileURL.lastPathComponent == fileName {
                    return fileURL
                }
            }
        } else {
            // List the contents of the directory (non-recursively)
            do {
                let contents = try self.contentsOfDirectory(
                    at: directory,
                    includingPropertiesForKeys: nil,
                    options: []
                )
                return contents.first { $0.lastPathComponent == fileName }
            } catch {
                print("Error reading directory contents: \(error)")
            }
        }
        return nil
    }
    
    func isDirectory(_ url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    
    var desktopDirectoryForCurrentUser: URL {
        return FileManager
            .default
            .homeDirectoryForCurrentUser
            .appendingPathComponent("/Desktop")
    }
}

extension UserDefaults {
    static func resetUserDefaults() {
        let defaults = UserDefaults.standard
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        print("✅ UserDefaults reset successfully.")
    }
}
