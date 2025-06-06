import SwiftUI
import GEmojiPicker

struct WorkspaceEditForm: View {
    var initialName: String
    var initialEmoji: String
    var saveCallback: (_ name: String, _ emoji: String) -> Void
    var cancelCallback: () -> Void
    
    @State private var workspaceName: String
    @State private var workspaceEmoji: String
    @StateObject private var sharedEmojiState = SharedState()
    @State private var showingEmojiPalette = false
    @FocusState private var nameFieldFocused: Bool
    
    init(initialName: String, initialEmoji: String, onSave: @escaping (_: String, _: String) -> Void, onCancel: @escaping () -> Void) {
        self.initialName = initialName
        self.initialEmoji = initialEmoji
        self.saveCallback = onSave
        self.cancelCallback = onCancel
        _workspaceName = State(initialValue: initialName)
        _workspaceEmoji = State(initialValue: initialEmoji)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: cancelEdit) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                Button(action: saveWorkspace) {
                    Text("Save")
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
                    .focused($nameFieldFocused)
                    .onSubmit {
                        if !workspaceName.isEmpty {
                            saveWorkspace()
                        }
                    }
            }
        }
        .onAppear {
            nameFieldFocused = true
        }
        .onExitCommand {
            cancelEdit()
        }
    }
    
    private func saveWorkspace() {
        saveCallback(workspaceName, workspaceEmoji)
    }
    
    private func cancelEdit() {
        cancelCallback()
    }
} 