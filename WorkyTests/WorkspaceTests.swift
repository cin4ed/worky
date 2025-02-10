//
//  WorkspaceTests.swift
//  WorkyTests
//
//  Created by Kenneth Quintero on 16/01/25.
//

import XCTest

import Testing
@testable import Worky

@Suite("Workspace Struct Tests")
struct WorkspaceTests {
    @Test("Memberwise initialization sets correct default values")
    func memberwiseInitializationSetsCorrectDefaultValues() {
        let name = "School"
        let emoji = "🏫"
        
        let workspace = Workspace(
            name: name,
            emoji: emoji
        )
        
        #expect(workspace.name == name)
        #expect(workspace.emoji == emoji)
        #expect(workspace.itemCount == 0)
        #expect(workspace.url == FileManager.default.temporaryDirectory)
    }
    
    @Test("Two workspaces cannot share the same ID")
    func twoWorkspacesCannotShareTheSameID() {
        let workspace1 = Workspace(name: "Workspace 1", emoji: "🏠")
        let workspace2 = Workspace(name: "Workspace 2", emoji: "🏢")
        
        #expect(workspace1.id != workspace2.id)
    }
    
    @Test("createDirectory method creates a directory")
    func createDirectoryMethodCreatesDirectory() throws {
        let workspace = Workspace(name: "Test Workspace", emoji: "🛠️")
        
        let createdDirectory = try workspace.createDirectory(
            at: FileManager.default.temporaryDirectory
        )
        
        #expect(FileManager.default.fileExists(atPath: createdDirectory.path))
    }
    
    @Test("saveAsJSON method creates a JSON file")
    func saveAsJSONCreatesAJSONFile() throws {
        let workspace = Workspace(name: "Test Workspace", emoji: "🛠️")
        
        let jsonFileURL = try workspace.saveAsJSON(
            at: FileManager.default.temporaryDirectory
        )
        
        #expect(FileManager.default.fileExists(atPath: jsonFileURL.path))
    }
    
    @Test("Initialization from a valid JSON creates a workspace successfully")
    func initFromValidJSONCreatesWorkspaceSuccessfully() throws {
        let workspaceName = "My Workspace"
        let workspaceURL = FileManager.default.temporaryDirectory.appendingPathComponent(
            workspaceName
        )
        
        let validJSON = """
            {
                "id": "3b2ac053-6c53-4c68-b6cc-728e78871854",
                "name": "My Workspace",
                "emoji": "🚀",
                "itemCount": 5,
                "url": "\(workspaceURL.absoluteString)"
            }
            """.data(using: .utf8)!
        
        let workspace = try Workspace(from: validJSON)
        
        #expect(workspace != nil)
        #expect(workspace?.name == "My Workspace")
        #expect(workspace?.emoji == "🚀")
        #expect(workspace?.itemCount == 5)
        #expect(workspace?.url == workspaceURL)
    }
    
    @Test("Initialization from an invalid JSON throws error when decoding")
    func initFromInvalidJSONThowsErrorWhenDecoding() {
        let invalidJSON = """
            {
                "name": "Invalid Workspace",
                "emoji": "❌"
                // Missing required fields
            }
            """.data(using: .utf8)!
        
        #expect(throws: DecodingError.self) {
            try Workspace(from: invalidJSON)
        }
    }
    
    @Test("Find workspace configuration file")
    func testFindConfigFile() throws {
        
    }
    
    @Test("Initialization from a valid workspace directory")
    func initFromValidWorkspaceDirectory() async throws {
        let workspace = Workspace(
            name: "Test Workspace",
            emoji: "🚀"
        )
        
        try workspace.saveAsJSON(
            at: workspace.url
        )
        
        let decodedWorkspace = try Workspace(from: workspace.url)
        
        #expect(decodedWorkspace != nil)
    }
}
