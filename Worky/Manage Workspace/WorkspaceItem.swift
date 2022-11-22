//
//  WorkspaceItem.swift
//  Worky
//
//  Created by Kenneth Quintero on 04/08/22.
//

import SwiftUI

struct WorkspaceItem: View {
    @State var workspace: Workspace
    @State private var presentingAlert = false
    @State private var overExport = false
    @State private var overDelete = false
    @Binding var updater: Bool
    
    var body: some View {
        HStack {
            Text(workspace.emoji)
            Text(workspace.title)
            
            Spacer()
            
            // Export button
            Button {
                // Export: shows the workspace directory in finder
                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: workspace.url.path)
            } label: {
                Image(systemName: "square.and.arrow.up.fill")
            }
            .help("Export Workspace")
            .buttonStyle(PlainButtonStyle())
            .onHover { over in overExport = over }
            .background {
                if overExport {
                    Rectangle()
                        .fill(Color(.sRGB, red: 255, green: 255, blue: 255, opacity: 0.2))
                        .cornerRadius(2.5)
                        .frame(width: 20, height: 20)
                } else {
                    EmptyView()
                }
            }

            // Delete button
            Button { presentingAlert = true } label: {
                Image(systemName: "trash.fill")
            }
            .buttonStyle(PlainButtonStyle())
            .onHover { over in overDelete = over }
            .background {
                if overDelete {
                    Rectangle()
                        .fill(Color(.sRGB, red: 255, green: 255, blue: 255, opacity: 0.2))
                        .cornerRadius(2.5)
                        .frame(width: 20, height: 20)
                } else {
                    EmptyView()
                }
            }
            .confirmationDialog(
                "Do you want to move\n\"\(workspace.emoji) \(workspace.title)\"\nto the trash can?",
                isPresented: $presentingAlert
            ) {
                Button("Move to trash", role: .destructive) {
                    workspace.delete()
                    presentingAlert = false
                    updater.toggle()
                }
            }
        }
        .padding(5)
    }
}
