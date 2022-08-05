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
    @State private var emoji: String = "📦"
    @State private var showingPopover = false
    private var columns: [GridItem] = Array(repeating: .init(.fixed(30)), count: 8)
    private var emojis: [Emoji] = Emoji.getAll()
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                ButtonEmoji
                
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
                        .frame(maxWidth: .infinity, maxHeight: 32)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.blue))
                }

                Button(action: cancelButtonHandler) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity, maxHeight: 32)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray))
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 250, height: nil)
        .padding()
        .background(VisualEffect())
        .onSubmit(createButtonHandler)
        .onExitCommand(perform: cancelButtonHandler)
    }
    
    private var ButtonEmoji: some View {
        Button($emoji.wrappedValue) {
            self.showingPopover = true
        }
        .frame(maxWidth: 40, maxHeight: 35)
        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
        .popover(isPresented: $showingPopover) {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach(emojis, id: \.self) {
                        let currEmoji = $0.emoji
                        Text(currEmoji)
                            .font(.largeTitle)
                            .onTapGesture {
                                self.emoji = currEmoji
                                self.showingPopover = false
                            }
                    }
                }
            }
            .frame(maxWidth: 500, maxHeight: 300)
            .padding(10)
        }
    }
}

extension CreateWorkspaceView {
    
    func createButtonHandler() -> Void {
        
        // Only create one if there's a name
        if !$name.wrappedValue.isEmpty {
            
            let workspace = Workspace(
                title: $name.wrappedValue,
                emoji: $emoji.wrappedValue,
                container: WorkyApp.container
            )
            
            Workspace.createDirectory(for: workspace)
            Workspace.serialize(workspace)
            Workspace.selectWorkspace(workspace)
        }
        
        // Reset
        self.name = ""
        self.emoji = "📦"
        
        CreateWorkspaceWindow.shared.close()
        
        WorkyModel.shared.update() // Update app model
    }
    
    func cancelButtonHandler() -> Void {
        // Reset
        self.name = ""
        self.emoji = "📦"
        
        CreateWorkspaceWindow.shared.close()
    }
}

struct CreateWorkspaceView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWorkspaceView()
    }
}

struct VisualEffect: NSViewRepresentable {
   func makeNSView(context: Self.Context) -> NSView {
       let visualEffect =  NSVisualEffectView()
       visualEffect.blendingMode = .behindWindow
       visualEffect.state = .active
       visualEffect.material = .hudWindow
       visualEffect.wantsLayer = true
       visualEffect.layer?.cornerRadius = 16
       return visualEffect
   }
   func updateNSView(_ nsView: NSView, context: Context) { }
}
