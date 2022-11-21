//
//  WorkyModelTests.swift
//  WorkyTests
//
//  Created by Kenneth Quintero on 20/11/22.
//

import XCTest
@testable import Worky

final class WorkyModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateContainerIfNeeded() {
        WorkyModel.createContainerIfNeeded()
        
        let containerExists = FileManager
            .default
            .fileExists(atPath: WorkyModel.containerURL.path)
        
        XCTAssert(containerExists)
    }
    
    // Unless modifying the methods to accept a parameter that
    func testDirectoriesExists() throws {
        let fm = FileManager.default
        
        let dirURL = WorkyModel
            .containerURL
            .appendingPathComponent("/TestingWorkyModel")
        
        try fm.createDirectory(
            at: dirURL,
            withIntermediateDirectories: true
        )
        
        XCTAssert(WorkyModel.directoriesExists())
        
        try fm.trashItem(at: dirURL, resultingItemURL: nil)
    }
    
    func testWorkspacesExists() {
        let workspace = Workspace(title: "TestWorkspaceExists")
        
        workspace.createDirectoryIfNeeded()
        
        XCTAssert(WorkyModel.workspacesExists())
        
        workspace.delete()
    }
    
    func testCurrentWorkspaceExists() {
        let fm = FileManager.default
        
        let workspace = Workspace(title: "TestCurrentWorkspaceExists")
        workspace.createDirectoryIfNeeded()
        workspace.select()
        
        XCTAssert(WorkyModel.currentWorkspace != nil)
        
        workspace.moveToItsDirectoryIfNeeded()
        workspace.delete()
    }
}
