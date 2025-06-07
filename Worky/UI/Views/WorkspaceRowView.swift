//
//  WorkspaceRowView.swift
//  Worky
//
//  Created by Kenneth Quintero on 09/02/25.
//


import SwiftUI

struct WorkspaceRowView: View {
    
    var workspace: Workspace
    var isCurrent: Bool = false
    var onUpdate: ((_ newName: String, _ newEmoji: String) -> Void)? = nil
    @State private var isHovered = false
    @State private var isEditing = false
    
    private var itemCountText: String {
        let count = workspace.itemCount
        return "\(count) \(count == 1 ? "item" : "items")"
    }
    
    var body: some View {
        HStack {
            Text(workspace.emoji).font(.title)
            Text(workspace.name).font(.body)
            Spacer()
            Text(itemCountText).font(.subheadline)
            Menu("") {
                Button("Edit", action: edit)
                if !isCurrent {
                    Button("Reveal in Finder", action: revealInFinder)
                }
            }
            .frame(maxWidth: 20)
            .menuStyle(BorderlessButtonMenuStyle())
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isHovered ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                .animation(.easeInOut(duration: 0.2), value: isHovered)
        )
        .onHover { hovering in
            isHovered = hovering
        }
        .sheet(isPresented: $isEditing) {
            WorkspaceEditForm(
                initialName: workspace.name,
                initialEmoji: workspace.emoji,
                onSave: { newName, newEmoji in
                    onUpdate?(newName, newEmoji)
                    isEditing = false
                },
                onCancel: {
                    isEditing = false
                }
            )
            .padding()
            .frame(width: 350)
        }
    }
    
    func edit() {
        isEditing = true
    }
    
    func revealInFinder() {
        guard let url = workspace.directory else { return }
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

#Preview {
    WorkspaceRowView(workspace: Workspace(name: "Testing"))
        .padding()
        .frame(maxWidth: 300)
}
