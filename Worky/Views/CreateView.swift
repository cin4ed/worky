//
//  CreateView.swift
//  Worky
//
//  Created by Kenneth Quintero on 24/01/25.
//

import SwiftUI
import GEmojiPicker

struct CreateView: View {
    let onCancel: () -> Void
    
    @StateObject private var shared = SharedState()
    @State private var showingEmojiPalette: Bool = false;
    @State private var name: String = "";
    
    var body: some View {
        VStack {
            Button(action: {
                showingEmojiPalette.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    Text(shared.selectedEmoji?.string ?? "📦")
                        .font(.system(size: 40))
                }
            }
            .buttonStyle(PlainButtonStyle())
            .popover(isPresented: $showingEmojiPalette) {
                EmojiPicker(emojiStore: EmojiStore(), selectionHandler: { emoji in
                    print(emoji)
                })
                .environmentObject(shared)
                .frame(width: 300, height: 300 )
            }
            
            TextField("Name", text: $name)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            
            HStack {
                Button(action: onCancel) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                Button(action: {
                    // Handle creation logic here
                }) {
                    Text("Create")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
    }
}


#Preview {
    CreateView(onCancel: {
        
    })
}
