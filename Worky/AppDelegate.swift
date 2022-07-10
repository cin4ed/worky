//
//  AppDelegate.swift
//  Worky
//
//  Created by Kenneth Quintero on 05/06/22.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    static let appStatusBar: NSStatusBar = NSStatusBar.system
    static private(set) var appStatusItem: NSStatusItem!
    static private(set) var appStatusItemMenu: AppStatusItemMenu!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // Setup the status bar item with its menu
        AppDelegate.appStatusItem = AppDelegate
            .appStatusBar
            .statusItem(withLength: NSStatusItem.squareLength)
        
        AppDelegate.appStatusItem.button!.title = "📦"
        
        AppDelegate.appStatusItemMenu = AppStatusItemMenu()
        AppDelegate.appStatusItem.menu = AppDelegate.appStatusItemMenu
    }
}
