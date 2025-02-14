//
//  WorkspaceRowView.swift
//  Worky
//
//  Created by Kenneth Quintero on 09/02/25.
//


import SwiftUI

struct WorkspaceRowView: View {
    
    var workspace: Workspace
    @State private var isHovered = false
    
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
                Button("Show in Finder", action: show)
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
    }
    
    func edit() {
        
    }
    
    func show() {
        
    }
}

#Preview {
    WorkspaceRowView(workspace: Workspace(name: "Testing"))
        .padding()
        .frame(maxWidth: 300)
}
