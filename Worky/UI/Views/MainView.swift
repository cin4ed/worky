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
        .onAppear(perform: clearFocus)
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
        if appController.currentWorkspace != nil {
            WorkspaceRowView(workspace: appController.currentWorkspace!)
        }
    }
    
    @ViewBuilder
    private var choosingWorkspaceSection: some View {
        sectionHeader("AVAILABLE")
        ScrollView(showsIndicators: false) {
            ChoosableWorkspacesList(
                onChoosenWorkspace: appController.chooseWorkspace,
                workspaces: appController.availableWorkspaces
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
