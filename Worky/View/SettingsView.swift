//
//  SettingsView.swift
//  Worky
//
//  Created by Kenneth Quintero on 13/07/22.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var workspaces = Workspace.getAllWorkspacesWithCurrent()
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section {
                    ForEach($workspaces) { $workspace in
                        // List item
                        HStack {
                            Text(workspace.emoji)
                            Text(workspace.title)
                            Spacer()
                            Button {
                                Workspace.deleteWorkspace(workspace)
                                workspaces = Workspace.getAllWorkspacesWithCurrent()
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(5)
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
        .onAppear {
            self.workspaces = Workspace.getAllWorkspacesWithCurrent()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
