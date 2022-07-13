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
    
    static var shared = AppStatusItemMenuDelegate()
    
    override private init() {}
    
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
            withTitle: "Toggle desktop visibility",
            action: #selector(toggleDesktop),
            keyEquivalent: ""
        ).target = self
        
        menu.addItem(.separator())
        
        let workspaces = Workspace.getWorkspaces()
            
        if workspaces.count > 0 {
            menu.addItem(
                withTitle: "Choose a workspace",
                action: nil,
                keyEquivalent: ""
            )
            
            for workspace in workspaces {
                let item = menu.addItem(
                    withTitle: "\(workspace.emoji) \(workspace.title)",
                    action: #selector(chooseWorkspace),
                    keyEquivalent: ""
                )
                item.representedObject = workspace
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
                withTitle: "\(workspace.emoji) \(workspace.title)",
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

    // MARK: Create workspace
    @objc func addNewWorkspace() {
        CreateWorkspaceWindow.shared.bringToFront()
    }

    // MARK: Hide desktop
    @objc func toggleDesktop() {
        AppleScriptExecutor.toggleDesktopVisibility()
    }
    
    // MARK: Quit appplication
    @objc func quitApp() {
        NSApp.terminate(self)
    }
}
