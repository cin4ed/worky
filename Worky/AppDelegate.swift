//
//  AppDelegate.swift
//  Worky
//
//  Created by Kenneth Quintero on 15/10/24.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    var popoverState = PopoverState()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(named: "status-bar-icon")
            button.action = #selector(togglePopover(_:))
        }

        // Initialize the popover
        popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 300, height: 350)
        popover.delegate = self
        popover.contentViewController = NSHostingController(rootView: PopoverView().environmentObject(popoverState));
      }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusBarItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                // Show the popover relative to the status bar item
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                
                // Make the popover key
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }
    
    // Restart to MainView when the user clicks outside the popover
    func popoverDidClose(_ notification: Notification) {
        popoverState.creatingWorkspace = false
    }
}

class  PopoverState: ObservableObject {
    @Published var creatingWorkspace: Bool = false
}
