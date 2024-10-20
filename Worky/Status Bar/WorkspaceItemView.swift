//
//  WorkspaceItemView.swift
//  Worky
//
//  Created by Kenneth Quintero on 17/10/24.
//

import SwiftUI

struct WorkspaceItemView: View {
    var workspace: WSWorkspace!

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

//struct WorkspaceItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceItemView(workspace: w)
//    }
//}
