//
//  CreateWorkspaceWindow.swift
//  Worky
//
//  Created by Kenneth Quintero on 11/07/22.
//

import Foundation
import SwiftUI

class CreateWorkspaceWindow: NSWindow {
    
    static var shared = CreateWorkspaceWindow()
    
    private init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        
        self.title = "Worky"
        self.isReleasedWhenClosed = false
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.contentView = NSHostingView(rootView: CreateWorkspaceView())
        self.center()
    }
    
    func bringToFront() {
        NSApp.activate(ignoringOtherApps: true)
        self.makeKeyAndOrderFront(nil)
    }
}

