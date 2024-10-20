//
//  PopoverView.swift
//  Worky
//
//  Created by Kenneth Quintero on 15/10/24.
//

import SwiftUI

struct WSWorkspace {
    var id: String
    var name: String
    var itemCount: Int
    var emoji: String
}

let workspaces: [WSWorkspace] = [
    WSWorkspace(id: "123", name: "School", itemCount: 5, emoji: "🏫"),
    WSWorkspace(id: "100", name: "Work", itemCount: 3, emoji: "🧳"),
    WSWorkspace(id: "dfj", name: "Developer", itemCount: 10, emoji: "💻"),
    WSWorkspace(id: "oie", name: "Books", itemCount: 7, emoji: "📚"),
    WSWorkspace(id: "lak", name: "Cooking", itemCount: 3, emoji: "🍳"),
    WSWorkspace(id: "laksd", name: "Movies", itemCount: 10, emoji: "🍿"),
    WSWorkspace(id: "lkaj", name: "Writing", itemCount: 33, emoji: "✍️"),
    WSWorkspace(id: "joj", name: "Games", itemCount: 12, emoji: "🎮"),
    WSWorkspace(id: "oio", name: "Blog", itemCount: 49, emoji: "🧑‍💻"),
    WSWorkspace(id: "qioo", name: "Drawing", itemCount: 11, emoji: "🎨")
]

let currentWorkspace: WSWorkspace = WSWorkspace(
    id: "qwer",
    name: "Testing",
    itemCount: 20,
    emoji: "⭐️"
)

struct PopoverView: View {
    @State private var hoveredIndex: Int? = nil
    
    var body: some View {
        VStack {
            HStack {
                Button {} label: {
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
        .padding(10)
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView()
    }
}
