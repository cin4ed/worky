//
//  WorkspaceTests.swift
//  WorkyTests
//
//  Created by Kenneth Quintero on 17/10/24.
//

import XCTest
@testable import Worky

final class WorkspaceTests: XCTestCase {
    func testMemberwiseInitializationSetsCorrectDefaultValues() {
        let name = "School"
        let emoji = "🏫"
        
        let workspace = Workspace(
            name: name,
            emoji: emoji
        )
        
        XCTAssertEqual(
            workspace.name,
            name,
            "Expected workspace name to be '\(name)', but got '\(workspace.name)' instead."
        )
        XCTAssertEqual(
            workspace.emoji,
            emoji,
            "Expected workspace emoji to be '\(emoji)', but got '\(workspace.emoji)' instead."
        )
        XCTAssertEqual(
            workspace.itemCount,
            0,
            "Expected workspace itemCount to be 0, but got \(workspace.itemCount) instead."
        )
        XCTAssertEqual(
            workspace.url,
            FileManager.default.temporaryDirectory,
            "Expected workspace URL to be \(FileManager.default.temporaryDirectory), but got \(workspace.url) instead."
        )
    }
    
    func testTwoWorkspacesCannotShareSameID() {
        let workspace1 = Workspace(name: "Workspace 1", emoji: "🏠")
        let workspace2 = Workspace(name: "Workspace 2", emoji: "🏢")
        
        XCTAssertNotEqual(
            workspace1.id,
            workspace2.id,
            "Expected two workspaces to have unique IDs, but both had the same ID: '\(workspace1.id)'."
        )
    }
    
    func testCreateDirectory_CreatesDirectory() throws {
        let workspace = Workspace(name: "Test Workspace", emoji: "🛠️")
        
        let createdDirectory = try workspace.createDirectory(
            at: FileManager.default.temporaryDirectory
        )
        
        XCTAssertTrue(
            FileManager.default.fileExists(atPath: createdDirectory.path),
            "Expected directory to exist at path '\(createdDirectory.path)', but it does not."
        )
    }
    
    func testSaveAsJSON_CreatesJSONFile() throws {
        let workspace = Workspace(name: "Test Workspace", emoji: "🛠️")
        
        let jsonFileURL = try workspace.saveAsJSON(
            at: FileManager.default.temporaryDirectory
        )
        
        XCTAssertTrue(
            FileManager.default.fileExists(atPath: jsonFileURL.path),
            "Expected JSON file to exists at path '\(jsonFileURL.path)', but it does not."
        )
    }
    
    func testInitFromValidJSONDecodesWorkspaceSuccessfully() throws {
        let workspaceName = "My Workspace"
        let workspaceURL = FileManager.default.temporaryDirectory.appendingPathComponent(
            workspaceName
        )
        
        print(workspaceURL.absoluteString)
        
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
        
        XCTAssertNotNil(
            workspace,
            "Expected a valid Workspace instance, but got nil."
        )
        XCTAssertEqual(
            workspace?.name,
            "My Workspace",
            "Expected workspace name to be 'My Workspace', but got '\(workspace?.name ?? "nil")'."
        )
        XCTAssertEqual(
            workspace?.emoji,
            "🚀",
            "Expected workspace emoji to be '🚀', but got '\(workspace?.emoji ?? "nil")'."
        )
        XCTAssertEqual(
            workspace?.itemCount,
            5,
            "Expected workspace itemCount to be 5, but got \(workspace?.itemCount ?? -1)."
        )
        XCTAssertEqual(
            workspace?.url,
            workspaceURL,
            "Expected workspace URL to match temporary directory, but got '\(workspace?.url ?? URL(string: "nil")!)'."
        )
    }
    
    func testInitFromInvalidJSONThrowsDecodingError() throws {
        let invalidJSON = """
        {
            "name": "Invalid Workspace",
            "emoji": "❌"
            // Missing required fields
        }
        """.data(using: .utf8)!
        
        XCTAssertThrowsError(
            try Workspace(from: invalidJSON),
            "Expected an error to be thrown for invalid JSON, but no error was thrown."
        ) { error in
            XCTAssertTrue(
                error is DecodingError,
                "Expected a DecodingError, but got \(type(of: error))."
            )
        }
    }
}
