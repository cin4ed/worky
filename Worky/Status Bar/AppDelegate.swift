//
//  AppDelegate.swift
//  Worky
//
//  Created by Kenneth Quintero on 15/10/24.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(named: "status-bar-icon")
            button.action = #selector(togglePopover(_:))
        }

        // Initialize the popover
        popover = NSPopover()
        popover.contentViewController = NSHostingController(rootView: PopoverView());
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 300, height: 350)
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
