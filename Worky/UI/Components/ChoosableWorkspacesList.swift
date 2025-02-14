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
    
    var body: some View {
        VStack {
            ForEach(Array(workspaces.enumerated()), id: \.element.id) { index, workspace in
                WorkspaceRowView(workspace: workspace)
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
