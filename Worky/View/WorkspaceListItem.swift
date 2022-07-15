//
//  WorkspaceListItem.swift
//  Worky
//
//  Created by Kenneth Quintero on 13/07/22.
//

import SwiftUI

/*
 Things to do:
    - Put a pencil symbol to edit the workspace name just before
    the trash symbol one.
 */

struct WorkspaceListItem: View {
    
    var workspace: Workspace
    
    var body: some View {
        HStack {
            Text(workspace.emoji)
            Text(workspace.title)
            Spacer()
            Button {
                Workspace.deleteWorkspace(workspace)
            } label: {
                Image(systemName: "trash.fill")
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(5)
    }
}

struct WorkspaceListItem_Previews: PreviewProvider {
    
    static let workspace = Workspace(
        title: "Proyecto final escuela",
        emoji: "🏫",
        url: URL(fileURLWithPath: "Placeholder"))
    
    static var previews: some View {
        WorkspaceListItem(workspace: Self.workspace)
            .frame(maxWidth: 300)
    }
}
