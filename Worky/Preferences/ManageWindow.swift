//
//  SettingsWindow.swift
//  Worky
//
//  Created by Kenneth Quintero on 13/07/22.
//

import Foundation
import SwiftUI

class ManageWindow: NSWindow {
    
    static var shared = ManageWindow()
    
    private init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 500),
            styleMask: [.titled, .fullSizeContentView, .closable],
            backing: .buffered,
            defer: false)
        
        self.title = "Worky Settings"
        self.isReleasedWhenClosed = false
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.contentView = NSHostingView(rootView: ManageView())
        self.center()
    }
    
    func bringToFront() {
        NSApp.activate(ignoringOtherApps: true)
        self.makeKeyAndOrderFront(nil)
    }
}
