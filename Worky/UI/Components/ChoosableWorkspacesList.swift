//
//  ChoosableWorkspacesList.swift
//  Worky
//
//  Created by Kenneth Quintero on 09/02/25.
//

import SwiftUI

struct ChoosableWorkspacesList: View {
    
    var onChoosenWorkspace: (_: Workspace) -> Void
    var workspaces: [Workspace]
    var onUpdateWorkspace: (_ oldWorkspace: Workspace, _ newName: String, _ newEmoji: String) -> Void
    
    var body: some View {
        VStack {
            ForEach(Array(workspaces.enumerated()), id: \.element.id) { index, workspace in
                WorkspaceRowView(
                    workspace: workspace,
                    isCurrent: false,
                    onUpdate: { newName, newEmoji in
                        onUpdateWorkspace(workspace, newName, newEmoji)
                    }
                )
                .onTapGesture {
                    onChoosenWorkspace(workspace)
                }
            }
        }
    }
}

//#Preview {
//    ChoosableWorkspacesList(onChoosenWorkspace: { workspace in
//        
//    }, workspaces: Container.shared.getAvailableWorkspaces())
//    .frame(maxWidth: 300)
//}
