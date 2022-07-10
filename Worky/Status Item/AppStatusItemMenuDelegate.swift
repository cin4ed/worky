//
//  AppStatusItemMenuDelegate.swift
//  Worky
//
//  Created by Kenneth Quintero on 08/07/22.
//

import Foundation
import AppKit
import SwiftUI

class AppStatusItemMenuDelegate: NSObject, NSMenuDelegate {
    
    static var shared: AppStatusItemMenuDelegate = {
        let instance = AppStatusItemMenuDelegate()
        return instance
    }()
    
    override private init() {}
    
    // Helper property used to store the create new workspace window
    static var newWorkspaceWindow: NSWindow?
    
    // MARK: Menu items
    func menuWillOpen(_ menu: NSMenu) {
        menu.removeAllItems()

        menu.addItem(
            withTitle: "Worky \(String(describing: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String))",
            action: nil,
            keyEquivalent: ""
        )
        
        menu.addItem(
            withTitle: "Add new",
            action: #selector(addNewWorkspace),
            keyEquivalent: "a"
        ).target = self
        
        menu.addItem(
            withTitle: "Toggle desktop",
            action: #selector(hideDesktop),
            keyEquivalent: ""
        ).target = self
        
        menu.addItem(.separator())
        
        menu.addItem(
            withTitle: "Choose a workspace",
            action: nil,
            keyEquivalent: ""
        )
        
        let workspaces = Workspace.getWorkspaces()
            
        if workspaces.count > 0 {
            for workspace in workspaces {
                let item = menu.addItem(
                    withTitle: workspace.title,
                    action: #selector(chooseWorkspace),
                    keyEquivalent: ""
                )
                item.target = self
            }
        } else {
            menu.addItem(
                withTitle: "No workspaces available",
                action: nil,
                keyEquivalent: ""
            )
        }
        
        if WorkyApp.currentWorkspace != nil {
        
            let workspace = WorkyApp.currentWorkspace!
            
            let menuItem = menu.addItem(
                withTitle: workspace.title,
                action: nil,
                keyEquivalent: "")
            
            menuItem.isEnabled = true
        }
            
        menu.addItem(.separator())
            
        menu.addItem(
            withTitle: "Settings",
            action: nil,
            keyEquivalent: ""
        ).target = self
        
        menu.addItem(
            withTitle: "Quit Worky",
            action: #selector(quitApp),
            keyEquivalent: "q"
        ).target = self
    }
    
    // MARK: Choose workspace
    @objc func chooseWorkspace(sender: NSMenuItem) {
        
        let workspace = sender.representedObject as! Workspace;
        Workspace.selectWorkspace(workspace)
    }
    
    // MARK: Delete workspace
    @objc func deleteWorkspace(sender: NSMenuItem) {
        
        let workspace = sender.representedObject as! Workspace;
        print("Workspace deleted: \(workspace.title)")
    }

    // MARK: New workspace
    @objc func addNewWorkspace() {

        // Crete a window to display a form to the user
        let window = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // Style the window and add the hosting view for the SwiftUI view
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.contentView = NSHostingView(rootView: CreateWorkspaceView())
        
        // Configure the delegate
        let delegate = WindowDelegate()
        window.delegate = delegate
        
        // Use the helper static property of this class to store the window
        // (needs to be stored in some place)
        AppStatusItemMenuDelegate.newWorkspaceWindow = window
        
        NSApp.runModal(for: window)
    }

    // MARK: Hide desktop
    @objc func hideDesktop() {
        AppleScriptExecutor.toggleDesktopVisibility()
    }
    
    // MARK: Quit appplication
    @objc func quitApp() {
        NSApp.terminate(self)
    }
}

extension AppStatusItemMenuDelegate {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

class WindowDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }
}
