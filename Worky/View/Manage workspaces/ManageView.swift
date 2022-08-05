//
//  SettingsView.swift
//  Worky
//
//  Created by Kenneth Quintero on 13/07/22.
//

import SwiftUI

struct ManageView: View {
    @StateObject private var worky = WorkyModel.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section {
                    ForEach($worky.workspaces, id: \.id) { $workspace in
                        WorkspaceItem(workspace: workspace)
                            .environmentObject(worky)
                    }
                } header: {
                    Text("Workspaces")
                } footer: {
                    Text("\($worky.workspaces.count) workspaces")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
