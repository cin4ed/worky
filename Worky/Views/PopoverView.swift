//
//  PopoverView.swift
//  Worky
//
//  Created by Kenneth Quintero on 24/01/25.
//

import SwiftUI
import GEmojiPicker

struct PopoverView: View {
    
    @State private var userCreatingWorkspace = false
    var createWorkspaceHandler: (_ name: String, _ emoji: String) -> Void
    var chooseWorkspaceHandler: (_ workspace: Workspace) -> Void
    var desktop = Desktop.shared
    var container = Container.shared
    
    init(onCreateWorkspace: @escaping (_ name: String, _ emoji: String) -> Void, onChooseWorkspace: @escaping (_ workspace: Workspace) -> Void )
    {
        createWorkspaceHandler = onCreateWorkspace
        chooseWorkspaceHandler = onChooseWorkspace
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if userCreatingWorkspace {
                WorkspaceCreationForm(
                    onCreate: createWorkspaceHandler,
                    onCancel: { userCreatingWorkspace = false }
                )
            } else {
                HStack {
                    createButton
                    settingsButton
                }
            }
            currentWorkspaceSection
            choosingWorkspaceSection
        }
        .onAppear(perform: clearFocus)
        .padding(10)
    }
    
    private func clearFocus() {
        DispatchQueue.main.async {
            NSApplication.shared.keyWindow?.makeFirstResponder(nil)
        }
    }
    
    private var createButton: some View {
        Button(action: { userCreatingWorkspace = true }) {
            Text("Create New")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
    
    private var settingsButton: some View {
        Button(action: { /* Add gear action */ }) {
            Image(systemName: "gear")
        }
        .controlSize(.large)
    }
    
    @ViewBuilder
    private var currentWorkspaceSection: some View {
        sectionHeader("CURRENT")
        if Desktop.shared.currentWorkspace != nil {
            WorkspaceRowView(workspace: Desktop.shared.currentWorkspace!)
        }
    }
    
    @ViewBuilder
    private var choosingWorkspaceSection: some View {
        sectionHeader("AVAILABLE")
        ScrollView(showsIndicators: false) {
            ChoosableWorkspacesList(onChoosenWorkspace: chooseWorkspaceHandler, workspaces: container.getAvailableWorkspaces())
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        HStack {
            Text(text)
                .font(.footnote)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

#Preview {
    // Create mock closures for the preview
    PopoverView(
        onCreateWorkspace: { name, emoji in
            print("Creating workspace: \(name) \(emoji)")
        },
        onChooseWorkspace: { workspace in
            print("Choosing workspace: \(workspace.name)")
        }
    )
}
