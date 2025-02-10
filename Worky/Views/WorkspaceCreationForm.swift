//
//  WorkspaceCreateForm.swift
//  Worky
//
//  Created by Kenneth Quintero on 10/02/25.
//

import SwiftUI
import GEmojiPicker

struct WorkspaceCreationForm: View {
    
    var onCreateWorkspace: (_ name: String, _ emoji: String) -> Void
    var onCancel: () -> Void
    
    init(onCreate: @escaping (_ name: String, _ emoji: String) -> Void, onCancel: @escaping () -> Void) {
        onCreateWorkspace = onCreate
        self.onCancel = onCancel
    }
    
    @State private var workspaceName: String = "";
    @State private var workspaceEmoji: String = "📦";
    @StateObject private var sharedEmojiState = SharedState()
    @State private var showingEmojiPalette = false;

    var body: some View {
        VStack {
            HStack {
                Button(action: onCancelCreation) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                Button(action: createWorkspaceHandler) {
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
                            .fill(.secondary.opacity(0.1)) // Use .secondary directly
                            .frame(width: 35, height: 35)
                        Text(workspaceEmoji)
                            .font(.system(size: 20))
                    }
                }
                .buttonStyle(.plain) // Use .plain for simple button styles
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
    
    private func createWorkspaceHandler() {
        
    }
    
    private func onCancelCreation() {
        workspaceName = ""
        workspaceEmoji = "📦"
    }
}

//#Preview {
//    WorkspaceCreationForm(onCreateWorkspace: { st, arg  in
//    })
//}
