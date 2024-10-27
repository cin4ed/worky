//
//  MainView.swift
//  Worky
//
//  Created by Kenneth Quintero on 22/10/24.
//

import SwiftUI

struct MainView: View {
    
    let onCreateNew: () -> Void
    @State private var hoveredIndex: Int? = nil
    
    let workspaces: [Workspace] = [
        Workspace(name: "School", emoji: "🏫", itemCount: 5),
        Workspace(name: "Work", emoji: "🧳", itemCount: 3),
        Workspace(name: "Developer", emoji: "💻", itemCount: 10),
        Workspace(name: "Books", emoji: "📚", itemCount: 7),
        Workspace(name: "Cooking", emoji: "🍳", itemCount: 3),
        Workspace(name: "Movies", emoji: "🍿", itemCount: 10),
        Workspace(name: "Writing", emoji: "✍️", itemCount: 33),
        Workspace(name: "Games", emoji: "🎮", itemCount: 12),
        Workspace(name: "Blog", emoji: "🧑‍💻", itemCount: 49),
        Workspace(name: "Drawing", emoji: "🎨", itemCount: 11)
    ]
    
    let currentWorkspace = Workspace(name: "Home", emoji: "🏠", itemCount: 11)
    
    var body: some View {
        VStack {
            HStack {
                Button(action: onCreateNew) {
                    Text("Create new")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                Button {} label: {
                    Image(systemName: "gear")
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("CURRENT")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                WorkspaceItemView(workspace: currentWorkspace)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.primary.opacity(0.15))
                    )
            }
            Spacer()
                .frame(height: 10)
            HStack {
                Text("WORKSPACES")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    ForEach(Array(workspaces.enumerated()), id: \.element.name) { index, workspace in
                        WorkspaceItemView(workspace: workspace)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(hoveredIndex == index ? Color.gray.opacity(0.12) : Color.clear)
                            )
                            .onHover { isHovering in
                                hoveredIndex = isHovering ? index : nil
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .frame(width: 300, height: 330)
    }
}

//struct MainPopoverView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainPopoverView()
//    }
//}
