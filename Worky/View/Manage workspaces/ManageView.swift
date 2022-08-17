//
//  SettingsView.swift
//  Worky
//
//  Created by Kenneth Quintero on 13/07/22.
//

import SwiftUI
import LaunchAtLogin

struct ManageView: View {
    @StateObject private var worky = WorkyModel.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            TabView {
                List {
                    Section {
                        ForEach($worky.workspaces, id: \.id) { $workspace in
                            WorkspaceItem(workspace: workspace)
                                .environmentObject(worky)
                        }
                    } header: {
                        HStack {
                            Text("Workspaces:")
                            Spacer()
                            Text("\($worky.workspaces.count) workspaces")
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ManageView()
    }
}
