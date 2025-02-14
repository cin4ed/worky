//
//  SettingsWindow.swift
//  Worky
//
//  Created by Kenneth Quintero on 12/02/25.
//

import Foundation

import Foundation
import SwiftUI

class SettingsWindowController {
    
    static let shared = SettingsWindowController()
    
    private var window: NSWindow?
    
    private init() {}
    
    func show() {
        if (window == nil) {
            let newWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
                styleMask: [.titled, .fullSizeContentView, .closable],
                backing: .buffered,
                defer: false
            )
            
            newWindow.title = "Worky Preferences"
            newWindow.isReleasedWhenClosed = false
            newWindow.contentView = NSHostingView(rootView: SettingsView(updater: AppDependencies.shared.updaterController.updater))
            newWindow.center()
            window = newWindow
        }
        
        NSApp.activate(ignoringOtherApps: true)
        window?.makeKeyAndOrderFront(nil)
    }
}
