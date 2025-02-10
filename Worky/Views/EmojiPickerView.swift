//
//  EmojiPickerView.swift
//  Worky
//
//  Created by Kenneth Quintero on 09/02/25.
//


import SwiftUI
import GEmojiPicker

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    @EnvironmentObject var sharedEmojiState: SharedState // Use the same environment object
    
    var body: some View {
        EmojiPicker(
            emojiStore: EmojiStore(),
            selectionHandler: { emoji in
                selectedEmoji = emoji.string
            })
        .environmentObject(sharedEmojiState)
    }
}