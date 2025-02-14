//
//  WorkspaceCreateForm.swift
//  Worky
//
//  Created by Kenneth Quintero on 10/02/25.
//

import SwiftUI
import GEmojiPicker

struct WorkspaceCreationForm: View {
    
    var createCallback: (_ : String, _ : String) -> Void
    var cancelCallback: () -> Void
    
    init(onCreate: @escaping (_ : String, _ : String) -> Void, onCancel: @escaping () -> Void) {
        self.createCallback = onCreate
        self.cancelCallback = onCancel
    }
    
    @State private var workspaceName: String = "";
    @State private var workspaceEmoji: String = "📦";
    @StateObject private var sharedEmojiState = SharedState()
    @State private var showingEmojiPalette = false;

    var body: some View {
        VStack {
            HStack {
                Button(action: cancelCreation) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                Button(action: createWorkspace) {
                    Text("Create")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(workspaceName.isEmpty)
            }
            HStack {
                Button(action: { showingEmojiPalette.toggle() }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.secondary.opacity(0.1))
                            .frame(width: 35, height: 35)
                        Text(workspaceEmoji)
                            .font(.system(size: 20))
                    }
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showingEmojiPalette) {
                    EmojiPickerView(selectedEmoji: $workspaceEmoji)
                        .environmentObject(sharedEmojiState)
                        .frame(width: 300, height: 300)
                }
                
                TextField("Name", text: $workspaceName)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(.secondary.opacity(0.1))
                    .cornerRadius(8)
            }
            
        }
    }
    
    private func createWorkspace() {
        createCallback(workspaceName, workspaceEmoji)
    }
    
    private func cancelCreation() {
        workspaceName = ""
        workspaceEmoji = "📦"
        cancelCallback()
    }
}
