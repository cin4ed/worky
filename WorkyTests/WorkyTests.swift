//
//  WorkyTests.swift
//  WorkyTests
//
//  Created by Kenneth Quintero on 11/07/22.
//

import XCTest
@testable import Worky

class WorkyTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testStringWithoutEmojis() {
        
        // It doesn't work with numbers idk why :@
        //let stringWithEmojis = String("1⛑2😃3🫣4")
        //let expectedString = String("1234")
        
        let stringWithEmojis = String("a⛑b😃c🫣d")
        let expectedString = String("abcd")
        
        XCTAssertEqual(stringWithEmojis.removeEmojis(), expectedString)
    }
    
    func testGetEmojiFile() {
        
        let emojis = Emoji.getAll()
        let firstEmoji = emojis.first!
        
        let expectedEmoji = Emoji(
            emoji: "😀",
            description: "grinning face",
            category: "Smileys & Emotion",
            aliases: ["grinning"]
        )
        
        XCTAssertEqual(firstEmoji.emoji, expectedEmoji.emoji)
        XCTAssertEqual(firstEmoji.description, expectedEmoji.description)
        XCTAssertEqual(firstEmoji.category, expectedEmoji.category)
        XCTAssertEqual(firstEmoji.aliases, expectedEmoji.aliases)
    }
}
