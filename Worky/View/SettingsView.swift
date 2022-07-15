//
//  SettingsView.swift
//  Worky
//
//  Created by Kenneth Quintero on 13/07/22.
//

import SwiftUI

struct SettingsView: View {
    
    var  workspaces = Workspace.getWorkspaces()
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section {
                    ForEach(workspaces) { workspace in
                        WorkspaceListItem(workspace: workspace)
                    }
                } header: {
                    Text("Workspaces")
                } footer: {
                    Text("\(workspaces.count) workspaces")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .listStyle(.plain)
        }
        .frame(maxWidth: 300)
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
