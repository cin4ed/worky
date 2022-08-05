//
//  WorkspaceItem.swift
//  Worky
//
//  Created by Kenneth Quintero on 04/08/22.
//

import SwiftUI

struct WorkspaceItem: View {
    @EnvironmentObject var worky: WorkyModel
    @State var workspace: Workspace
    @State var presentingAlert = false
    
    var body: some View {
        HStack {
            Text(workspace.emoji)
            Text(workspace.title)
            Spacer()
            Button { presentingAlert = true } label: {
                Image(systemName: "trash.fill")
            }
            .buttonStyle(PlainButtonStyle())
            .confirmationDialog(
                "Do you want to move\n[\(workspace.emoji) \(workspace.title)]\nto the trash can?",
                isPresented: $presentingAlert) {
                Button("Move to trash", role: .destructive) {
                    Workspace.deleteWorkspace(workspace)
                    presentingAlert = false
                    worky.update()
                }
            }
        }
        .padding(5)
    }
}
