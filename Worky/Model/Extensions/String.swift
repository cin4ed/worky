//
//  String.swift
//  Worky
//
//  Created by Kenneth Quintero on 11/07/22.
//

import Foundation

extension String {
    
    // Remove emojis from string
    func removeEmojis() -> String {
        self.unicodeScalars
            .filter { !$0.properties.isEmoji }
            .reduce("") { $0 + String($1) }
    }
}
