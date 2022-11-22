//
//  SettingsView.swift
//  Worky
//
//  Created by Kenneth Quintero on 13/07/22.
//

import SwiftUI
import LaunchAtLogin

struct ManageView: View {
    var body: some View {
        VStack(alignment: .leading) {
            TabView {
                List {
                    Section {
                        ForEach(WorkyModel.workspaces, id: \.id) { workspace in
                            WorkspaceItem(workspace: workspace)
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
                    CheckForUpdatesView(updaterViewModel: UpdaterViewModel())
                }.tabItem {
                    Text("Settings")
                }
            }
        }
        .frame(maxWidth: 300)
        .padding()
    }
}
