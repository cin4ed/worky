//
//  WorkspaceItemView.swift
//  Worky
//
//  Created by Kenneth Quintero on 24/01/25.
//

import SwiftUI

struct WorkspaceItemView: View {
    var workspace: Workspace!
    
    var body: some View {
        HStack {
            Text(workspace.emoji)
                .font(.title)
            VStack(alignment: .leading) {
                Text("\(workspace.name)")
                    .font(.body)
                Text("\(workspace.itemCount) items")
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 10)
    }
}

#Preview {
    let workspace = Workspace(
        name: "My Workspace",
        emoji: "🤖"
    )
    
    WorkspaceItemView(workspace: workspace)
}
