//
//  MainView.swift
//  Worky
//
//  Created by Kenneth Quintero on 24/01/25.
//

import SwiftUI

struct MainView: View {
    let onCreateNew: () -> Void
    @State private var hoveredIndex: Int? = nil

    let workspaces: [Workspace]

    let currentWorkspace = Workspace(name: "Home", emoji: "🏠", itemCount: 11)

    var body: some View {
        VStack(spacing: 16) {
            HeaderView(onCreateNew: onCreateNew)

            SectionHeader(title: "CURRENT")
            WorkspaceItemView(workspace: currentWorkspace)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primary.opacity(0.1))
                )

            SectionHeader(title: "WORKSPACES")
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(workspaces.enumerated()), id: \.element.name) { index, workspace in
                        WorkspaceItemView(workspace: workspace)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(hoveredIndex == index ? Color.gray.opacity(0.1) : Color.clear)
                                    .animation(.easeInOut(duration: 0.2), value: hoveredIndex)
                            )
                            .onHover { isHovering in
                                hoveredIndex = isHovering ? index : nil
                            }
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .padding()
        .frame(width: 320, height: 400)
    }
}

struct HeaderView: View {
    let onCreateNew: () -> Void

    var body: some View {
        HStack {
            Button(action: onCreateNew) {
                Text("Create New")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Button(action: {
                // Add gear action
            }) {
                Image(systemName: "gear")
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.footnote)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
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
    
    MainView(onCreateNew: { }, workspaces: workspaces)
}
