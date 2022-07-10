//
//  ContentView.swift
//  Worky
//
//  Created by Kenneth Quintero on 28/05/22.
//

import SwiftUI
import Combine

struct CreateWorkspaceView: View {
    
    @State private var name: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Menu("📦") {
                    Text("Something")
                    Text("Something 1")
                }
                .menuStyle(CustomMenuStyle())
                
                TextField("Name", text: $name)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            
            HStack {
                Button(action: createButtonHandler) {
                    Text("Create")
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.blue))
                }.buttonStyle(PlainButtonStyle())

                Button(action: cancelButtonHandler) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray))
                }.buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 250, height: nil)
        .padding()
    }
}

fileprivate struct CustomMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .frame(width: 50, height: 50)
    }
}


extension CreateWorkspaceView {
    func createButtonHandler() -> Void {
        let workspace = Workspace(
            title: $name.wrappedValue,
            container: WorkyApp.container
        )
        
        Workspace.createDirectory(for: workspace)
        Workspace.serialize(workspace)
        Workspace.selectWorkspace(workspace)
        
        AppStatusItemMenuDelegate.newWorkspaceWindow!.close()
    }
    
    func cancelButtonHandler() -> Void {
        AppStatusItemMenuDelegate.newWorkspaceWindow!.close()
    }
}

struct CreateWorkspaceView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWorkspaceView()
    }
}
