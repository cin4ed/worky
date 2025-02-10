//
//  WorkspaceHelperTests.swift
//  WorkyTests
//
//  Created by Kenneth Quintero on 02/02/25.
//

import Testing
import Foundation
@testable import Worky

struct WorkspaceHelperTests {
    @Test("Find configuration file")
    func testFindConfigurationFile() async throws {
        // Create a mock configuration file inside a temporary directory
        let temporaryDir = FileManager.default.temporaryDirectory
        let configFileURL = temporaryDir.appending(path: ".workspace.json")
        let fileCreated = FileManager.default.createFile(atPath: configFileURL.path, contents: nil)
        #expect(fileCreated == true, "Mock workspace configuration file not created")
        
        // Call the static function and verify the returned URL
        let foundURL = WorkspaceHelper.findConfigurationFile(in: temporaryDir)
        #expect(foundURL != nil, "")
        #expect(foundURL == configFileURL, "")
    }
}
