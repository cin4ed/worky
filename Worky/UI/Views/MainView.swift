//
//  PopoverView.swift
//  Worky
//
//  Created by Kenneth Quintero on 24/01/25.
//

import SwiftUI
import GEmojiPicker
import Sparkle

struct MainView: View {
    
    @State private var userCreatingWorkspace = false
    @State private var availableWorkspaces: [Workspace] = []
    @State private var currentWorkspace: Workspace? = nil
    let appController: AppController

    init(_ appController: AppController) {
        self.appController = appController
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if userCreatingWorkspace {
                WorkspaceCreationForm(
                    onCreate: appController.createWorkspace,
                    onCancel: { userCreatingWorkspace = false }
                )
            } else {
                HStack {
                    createWorkspaceButton
                    showSettingsButton
                }
            }
            currentWorkspaceSection
            choosingWorkspaceSection
        }
        .onAppear(perform: {
            clearFocus()
            availableWorkspaces = appController.availableWorkspaces
            currentWorkspace = appController.currentWorkspace
        })
        .padding(10)
    }
    
    private func clearFocus() {
        DispatchQueue.main.async {
            NSApplication.shared.keyWindow?.makeFirstResponder(nil)
        }
    }
    
    private var createWorkspaceButton: some View {
        Button(action: { userCreatingWorkspace = true }) {
            Text("Create New")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
    
    private var showSettingsButton: some View {
        Button(action: {
            SettingsWindowController.shared.show()
        }) {
            Image(systemName: "gear")
        }
        .controlSize(.large)
    }
    
    @ViewBuilder
    private var currentWorkspaceSection: some View {
        sectionHeader("CURRENT")
        if let current = currentWorkspace {
            WorkspaceRowView(
                workspace: current,
                isCurrent: true,
                onUpdate: { newName, newEmoji in
                    var updated = current
                    // Rename the directory in the container if it exists
                    if let oldDir = updated.directory, appController.container.directoryExists(oldDir) {
                        let parentDir = oldDir.deletingLastPathComponent()
                        if newName != updated.name {
                            try? updated.renameDirectory(to: newName, in: parentDir)
                        }
                    }
                    updated.name = newName
                    updated.emoji = newEmoji
                    // Always save to the desktop directory
                    try? updated.saveAsJSON(at: appController.desktop.directory)
                    // Refresh available workspaces list
                    availableWorkspaces = appController.availableWorkspaces
                    // Refresh current workspace
                    currentWorkspace = appController.currentWorkspace
                }
            )
        }
    }
    
    @ViewBuilder
    private var choosingWorkspaceSection: some View {
        sectionHeader("AVAILABLE")
        ScrollView(showsIndicators: false) {
            ChoosableWorkspacesList(
                onChoosenWorkspace: appController.chooseWorkspace,
                workspaces: availableWorkspaces,
                onUpdateWorkspace: { oldWorkspace, newName, newEmoji in
                    // Update the workspace in the array
                    guard let idx = availableWorkspaces.firstIndex(where: { $0.id == oldWorkspace.id }) else { return }
                    var updated = oldWorkspace
                    // If the name changed, rename the directory
                    if newName != oldWorkspace.name, let parentDir = oldWorkspace.directory?.deletingLastPathComponent() {
                        try? updated.renameDirectory(to: newName, in: parentDir)
                    }
                    updated.name = newName
                    updated.emoji = newEmoji
                    availableWorkspaces[idx] = updated
                    // Persist changes
                    if let dir = updated.directory {
                        try? updated.saveAsJSON(at: dir)
                    }
                }
            )
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
