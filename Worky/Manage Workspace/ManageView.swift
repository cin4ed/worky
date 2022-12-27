//
//  SettingsView.swift
//  Worky
//
//  Created by Kenneth Quintero on 13/07/22.
//

import SwiftUI
import LaunchAtLogin

struct ManageView: View {
    @State var updater: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            TabView {
                List {
                    // <Hacky Update>
                    if updater {
                        Text("")
                            .isHidden(true, remove: true)
                    }
                    // </Hacky Update>
                    Section {
                        if let currentWorkspace = WorkyModel.currentWorkspace {
                            WorkspaceItem(workspace: currentWorkspace, updater: $updater)
                        }
                        ForEach(WorkyModel.workspaces, id: \.id) { workspace in
                            WorkspaceItem(workspace: workspace, updater: $updater)
                        }
                    } header: {
                        HStack {
                            Text("Workspaces:")
                            Spacer()
                            Text("\(WorkyModel.workspaces.count) workspaces")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }.tabItem {
                    Text("Workspaces")
                }
                VStack {
                    LaunchAtLogin.Toggle()
                    CheckForUpdatesView(updater: WorkyApp.updaterController.updater)
                }.tabItem {
                    Text("Settings")
                }
            }
        }
        .frame(maxWidth: 300)
        .padding()
    }
}

// Only for hacky update
extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
