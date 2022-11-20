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
    
    // This is because:
    // https://stackoverflow.com/questions/33028404/unable-to-focus-on-nstextfields-from-modal-window
//    override var canBecomeKey: Bool { true }
    
    private init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.nonactivatingPanel, .titled, .fullSizeContentView, .borderless],
            backing: .buffered,
            defer: false)
        
//        self.isFloatingPanel = true
        self.level = .floating
        self.isOpaque = false
        self.backgroundColor = .clear
        self.titleVisibility = .hidden
        self.styleMask.remove(.titled)
        self.isMovableByWindowBackground = true
        self.isReleasedWhenClosed = false
        
        self.title = "Worky"
        
        self.contentView = NSHostingView(rootView: CreateWorkspaceView())
        
        self.center()
    }
    
    func bringToFront() {
        NSApp.activate(ignoringOtherApps: true)
        self.makeKeyAndOrderFront(nil)
    }
}
