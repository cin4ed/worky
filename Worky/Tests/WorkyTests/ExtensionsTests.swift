//
//  ExtensionsTests.swift
//  WorkyTests
//
//  Created by Kenneth Quintero on 02/02/25.
//

import Testing
import Foundation
@testable import Worky

struct ExtensionsTests {
    @Test("Find file")
    func testFindFile() async throws {
        // Create an test file inside a temporary directory
        let temporaryDir = FileManager.default.temporaryDirectory
        let fileName = "test.txt"
        let testFileURL = temporaryDir.appendingPathComponent(fileName)
        let fileCreated = FileManager.default.createFile(atPath: testFileURL.path(), contents: nil)
        #expect(fileCreated == true)
        
        // Try to find the test file
        let foundURL = FileManager.default.findFile(named: fileName, in: temporaryDir, recursively: false)
        #expect(foundURL == testFileURL)
    }
    
    @Test("Get real dekstop URL")
    func testGetRealDesktopURL() async throws {
        print(URL(fileURLWithPath: "file:///Users/kenneth/Desktop"))
    }
}
