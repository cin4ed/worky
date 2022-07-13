//
//  Emoji.swift
//  Worky
//
//  Created by Kenneth Quintero on 12/07/22.
//

import Foundation

struct Emoji: Decodable, Hashable {

    let emoji: String
    let description: String
    let category: String
    let aliases: [String]
}

extension Emoji {
    
    // If the test is passing this func shouldn't fail :|
    static func getAll() -> [Emoji] {
        var emojis: [Emoji] = []
        
        let path = Bundle.main.path(forResource: "emoji", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonRaw = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        if let jsonResult = jsonRaw as? [Dictionary<String, AnyObject>] {
            for result in jsonResult {
                emojis.append(
                    Emoji(
                        emoji: (result["emoji"] as? String)!,
                        description: (result["description"] as? String)!,
                        category: (result["category"] as? String)!,
                        aliases: (result["aliases"] as? [String])!
                    )
                )
            }
        }
        
        return emojis
    }
}
