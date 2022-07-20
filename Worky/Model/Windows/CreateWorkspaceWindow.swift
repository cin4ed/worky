//
//  CreateWorkspaceWindow.swift
//  Worky
//
//  Created by Kenneth Quintero on 11/07/22.
//

import Foundation
import SwiftUI

class CreateWorkspaceWindow: NSPanel {
    
    static var shared = CreateWorkspaceWindow()
    
    // This is because:
    // https://stackoverflow.com/questions/33028404/unable-to-focus-on-nstextfields-from-modal-window
    override var canBecomeKey: Bool { true }
    
    private init() {
        // Will leave all this shit here for learning purposes
//        super.init(
//            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
//            styleMask: [.titled, .fullSizeContentView],
//            backing: .buffered,
//            defer: false)
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.nonactivatingPanel, .titled, .fullSizeContentView, .borderless],
//            styleMask: [.nonactivatingPanel, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        
        self.isFloatingPanel = true
        self.level = .floating
//        self.collectionBehavior.insert(.fullScreenAuxiliary)
        self.isOpaque = false
        self.backgroundColor = .clear
        self.titleVisibility = .hidden
        self.styleMask.remove(.titled)
//        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.isReleasedWhenClosed = false
//        self.standardWindowButton(.closeButton)?.isHidden = true
//        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
//        self.standardWindowButton(.zoomButton)?.isHidden = true

        self.title = "Worky"
//        self.isReleasedWhenClosed = false
//        self.isOpaque = false
//        self.titleVisibility = .hidden
//        self.titlebarAppearsTransparent = true
        self.contentView = NSHostingView(rootView: CreateWorkspaceView())
        self.center()
    }
    
    func bringToFront() {
        NSApp.activate(ignoringOtherApps: true)
        self.makeKeyAndOrderFront(nil)
    }
}
