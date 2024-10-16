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
    WSWorkspace(id: "dfj", name: "Developer", itemCount: 10, emoji: "🧑‍💻"),
    WSWorkspace(id: "oie", name: "Books", itemCount: 7, emoji: "📚"),
    WSWorkspace(id: "lak", name: "Test", itemCount: 3, emoji: "📚"),
    WSWorkspace(id: "laksd", name: "Test2", itemCount: 10, emoji: "📚"),
    WSWorkspace(id: "lkaj", name: "Test3", itemCount: 33, emoji: "📚"),
    WSWorkspace(id: "joj", name: "Test4", itemCount: 12, emoji: "📚"),
    WSWorkspace(id: "oio", name: "Test5", itemCount: 49, emoji: "📚"),
    WSWorkspace(id: "qioo", name: "Test6", itemCount: 11, emoji: "📚")
]

struct PopoverView: View {
    @State private var hoveredIndex: Int? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(workspaces.enumerated()), id: \.element.name) { index, workspace in
                    HStack {
                        Text(workspace.emoji)
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text("\(workspace.name)")
                                .font(.headline)
                            Text("\(workspace.itemCount) items")
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(hoveredIndex == index ? Color.gray.opacity(0.2) : Color.gray.opacity(0.0))
                    .onHover { isHovering in
                        hoveredIndex = isHovering ? index : nil
                    }
                    
                    Divider()
                }
                
    //            Button("Quit") {
    //                NSApplication.shared.terminate(nil)
    //            }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(width: 330, height: 350, alignment: .top)
        .background(
            VisualEffectView(
                material: .toolTip,
                blendingMode: .behindWindow,
                state: .active
            )
        )
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.1), lineWidth: 1.5)
        )
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView()
    }
}
