//
//  WorkspaceTests.swift
//  WorkyTests
//
//  Created by Kenneth Quintero on 17/10/24.
//

import XCTest
@testable import Worky

final class WorkspaceTests: XCTestCase {
    
    var containerURL: URL!
    
    override func setUpWithError() throws {
        super.setUp()
        
        // Set up a temporary directory for testing
        let tempDirectory = FileManager.default.temporaryDirectory
        containerURL = tempDirectory.appendingPathComponent("workspacesTests")
        
        // Create the base test directory if it doesn't exist
        try? FileManager.default.createDirectory(at: containerURL, withIntermediateDirectories: true, attributes: nil)
    }

    override func tearDownWithError() throws {
        // Clean up the test directory after tests
        try? FileManager.default.removeItem(at: containerURL)
        super.tearDown()
    }
    
    // Test that a workspace instance is initialized with the correct values
    func testInitialization() {
        let name = "Personal Workspace"
        let emoji = "🏡"
        let itemCount = 5
        let url = URL(string: "file://PersonalWorkspace")!
        
        let workspace = Workspace(name: name, emoji: emoji, itemCount: itemCount, url: url)
        
        XCTAssertEqual(workspace.name, name)
        XCTAssertEqual(workspace.emoji, emoji)
        XCTAssertEqual(workspace.itemCount, itemCount)
        XCTAssertEqual(workspace.url, url)
    }
    
    func testUniqueIDs() {
        let workspace1 = Workspace(name: "Workspace 1", emoji: "🏠", itemCount: 2, url: URL(string: "file://Workspace1")!)
        let workspace2 = Workspace(name: "Workspace 2", emoji: "🏢", itemCount: 3, url: URL(string: "file://workspace2")!)
        
        XCTAssertNotEqual(workspace1.id, workspace2.id)
    }
    
    func testCreateDirectory_CreatesDirectory() throws {
        let workspace = Workspace(name: "Test Workspace", emoji: "🛠️")
        
        let createdDirectory = try workspace.createDirectory(at: containerURL)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: createdDirectory.path))
    }
    
    func testCreateDirectory_ExistsDirectory() throws {
        let workspace = Workspace(name: "Existing Workspace", emoji: "🛠️")
        
        // Create the directory initially
        _ = try workspace.createDirectory(at: containerURL)
        
        // Call the method again
        let existingDirectory = try workspace.createDirectory(at: containerURL)
        
        // Assert that the same directory is returned
        XCTAssertEqual(existingDirectory.path, containerURL.appendingPathComponent(workspace.name).path)
    }
    
    func testSaveAsJSON_CreatesHiddenFile() throws {
        let workspace = Workspace(name: "Test Workspace", emoji: "🛠️")
        
        let jsonFileURL = try workspace.saveAsJSON(at: containerURL)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: jsonFileURL.path), "The JSON file should exist.")
        XCTAssertTrue(jsonFileURL.lastPathComponent.hasPrefix("."), "The file should be a hidden file.")
        XCTAssertTrue(jsonFileURL.pathExtension == "json", "The file should have a .json extension.")
    }
    
    func testSaveAsJSON_FileContentIsCorrect() throws {
        var workspace = Workspace(name: "Test Workspace", emoji: "🛠️")
        workspace.url = containerURL
        
        let jsonFileURL = try workspace.saveAsJSON(at: containerURL)
        
        let jsonData = try Data(contentsOf: jsonFileURL)
        let decodedWorkspace = try JSONDecoder().decode(Workspace.self, from: jsonData)
        
        XCTAssertEqual(decodedWorkspace.name, workspace.name, "The name should match.")
        XCTAssertEqual(decodedWorkspace.emoji, workspace.emoji, "The emoji should match.")
        XCTAssertEqual(decodedWorkspace.url, workspace.url, "The url should match.")
    }
    
    func testSaveAsJSON_OverwritesExistingFile() throws {
        var workspace = Workspace(name: "Test Workspace", emoji: "🛠️")
        workspace.url = containerURL
        
        let firstSaveURL = try workspace.saveAsJSON(at: containerURL)
        
        // Modify the workspace and save again
        var updatedWorkspace = workspace
        updatedWorkspace.emoji = "💻"
        let secondSaveURL = try updatedWorkspace.saveAsJSON(at: containerURL)
        
        let jsonData = try Data(contentsOf: secondSaveURL)
        let decodedWorkspace = try JSONDecoder().decode(Workspace.self, from: jsonData)
        
        XCTAssertEqual(firstSaveURL, secondSaveURL, "The file URLs should be the same.")
        XCTAssertNotEqual(decodedWorkspace.emoji, workspace.emoji, "The emoji should reflect the updated value.")
    }
}
