//
//  AppStatusItemMenuDelegate.swift
//  Worky
//
//  Created by Kenneth Quintero on 08/07/22.
//

import Foundation
import AppKit

class AppStatusItemMenuDelegate: NSObject, NSMenuDelegate {
    
    static var shared = AppStatusItemMenuDelegate()
    
    override private init() {}
    
    // MARK: Menu items
    func menuWillOpen(_ menu: NSMenu) {
        // Clean the displaying menu
        menu.removeAllItems()

        // Add version number
        var workyVersion: String?
        
        if let bundleVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  {
            if let version = bundleVersionString as? String {
                workyVersion = version
            }
        }
        
        menu.addItem(
            withTitle: "Worky \(workyVersion ?? "")",
            action: nil,
            keyEquivalent: ""
        )
        
        menu.addItem(
            withTitle: "Add new workspace",
            action: #selector(addNewWorkspace),
            keyEquivalent: "a"
        ).target = self
        
        menu.addItem(
            withTitle: "Import as workspace",
            action: #selector(importAsWorkspace),
            keyEquivalent: ""
        ).target = self
        
        // Not working on all devices TODO: check why
//        menu.addItem(
//            withTitle: "Toggle desktop visibility",
//            action: #selector(toggleDesktop),
//            keyEquivalent: ""
//        ).target = self
        
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
            
        } else if WorkyApp.currentWorkspace == nil {
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
            withTitle: "Preferences",
            action: #selector(showManageWindow),
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
    @objc func showManageWindow(sender: NSMenuItem) {
//        let workspace = sender.representedObject as! Workspace;
//        print("Workspace deleted: \(workspace.title)")
        ManageWindow.shared.bringToFront()
    }

    // MARK: Create workspace
    @objc func addNewWorkspace() {
        CreateWorkspaceWindow.shared.bringToFront()
    }

    // MARK: Hide desktop
    @objc func toggleDesktop() {
        AppleScriptExecutor.toggleDesktopVisibility()
    }
    
    @objc func importAsWorkspace() {
        let panel = NSOpenPanel()
        panel.canCreateDirectories = true
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        
        let response = panel.runModal()
        let importURL = response == .OK ? panel.url : nil
          
        let fm = FileManager.default
        
        // Check whether the selected folder is inside worky directory already
        if !fm.fileExists(atPath: WorkyApp.container.appendingPathComponent(importURL!.lastPathComponent).path) {
            try! fm.moveItem(at: importURL!, to: WorkyApp.container!.appendingPathComponent(importURL!.lastPathComponent))
        } else {
            let alert = NSAlert()
            alert.icon = NSImage(named: "AppIcon")
            alert.messageText = "A workspace with the same already exists."
            alert.runModal()
            return
        }
        
        // Copy given directory
        let newWorkspace = Workspace(
            title: importURL!.lastPathComponent,
            emoji: "📦",
            url: WorkyApp.container!.appendingPathComponent(importURL!.lastPathComponent)
        )
        
        // Check if it's not serialized already
        if !fm.fileExists(atPath: newWorkspace.url.path+"/.worky.json") {
            Workspace.serialize(newWorkspace)
        }
        
        WorkyModel.shared.update()
    }
    
    // MARK: Quit appplication
    @objc func quitApp() {
        NSApp.terminate(self)
    }
}
