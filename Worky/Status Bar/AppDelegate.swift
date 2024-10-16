//
//  AppDelegate.swift
//  Worky
//
//  Created by Kenneth Quintero on 15/10/24.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var popoverWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the content view for the custom window
        let contentView = NSHostingView(rootView: PopoverView())

        // Create the status bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(named: "status-bar-icon")
            button.action = #selector(togglePopover(_:))
        }

        // Initialize the custom window
        popoverWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 330, height: 350),
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        
        popoverWindow?.isReleasedWhenClosed = false
        popoverWindow?.hasShadow = true
        popoverWindow?.level = .floating
        popoverWindow?.isOpaque = false
        popoverWindow?.backgroundColor = .clear
        
        popoverWindow?.contentView = contentView
      }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        guard let button = statusBarItem.button, let window = popoverWindow else { return }
        
        if window.isVisible {
            window.orderOut(nil)
        } else {
            // Position the window relative to the status bar item
            let buttonFrame = button.window?.frame ?? .zero
            let buttonOrigin = NSPoint(
                x: buttonFrame.origin.x - window.frame.width + 35,
                y: buttonFrame.origin.y - 5
            )
            window.setFrameTopLeftPoint(buttonOrigin)
            window.makeKeyAndOrderFront(true)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
    
//    @objc func togglePopover(_ sender: AnyObject?) {
//        if let button = statusBarItem?.button {
//            if popover.isShown {
//                popover.performClose(sender)
//            } else {
//                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
//
//                popover.contentViewController?.view.window?.makeKey()
//            }
//        }
//    }

//class AppDelegate: NSObject, NSApplicationDelegate {
//    func applicationDidFinishLaunching(_ notification: Notification) {
//        // Set app status item
//        WorkyApp.appStatusItem = WorkyApp
//            .appStatusBar
//            .statusItem(withLength: NSStatusItem.variableLength)
//        WorkyApp.appStatusItem.button!.image = NSImage(named: "status-bar-icon")
//        WorkyApp.appStatusItem.button!.image!.isTemplate = true
//
//        // Set app status item menu
//        WorkyApp.appStatusItemMenu = NSMenu(title: "Worky")
//        WorkyApp.appStatusItemMenuDelegate = MenuDelegate() as NSMenuDelegate
//        WorkyApp.appStatusItemMenu.delegate = WorkyApp.appStatusItemMenuDelegate
//        WorkyApp.appStatusItem.menu = WorkyApp.appStatusItemMenu
//
//        WorkyModel.createContainerIfNeeded()
//    }
//}

//    func applicationDidFinishLaunching(_ notification: Notification) {
//        // Set up the status bar item
//        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
//
//        if let button = statusBarItem?.button {
//            button.image = NSImage(named: "status-bar-icon")
//            button.action = #selector(togglePopover(_:))
//        }
//
//        // Configure the popover
//        popover.behavior = .transient
//        popover.contentViewController = NSHostingController(rootView: PopoverView())
//        popover.contentSize = NSSize(width: 200, height: 300)
//
//        WorkyModel.createContainerIfNeeded()
//    }
