//
//  WorkyApp.swift
//  Worky
//
//  Created by Kenneth Quintero on 28/05/22.
//

import SwiftUI
import AppKit
import Paddle

@main
struct WorkyApp: App {
    
    // The model is a class with all its properties static.
    //      - It's inside WorkyModel.swift.
    //      - Who uses WorkyModel.swift?
    //          - The app delegate
    //          - ...

    // There's a lot of fatalErrors triggered all over the place
    // that's a thing that should be handled better. But for simplicity
    // I'll just leave them.
    
    static let appStatusBar: NSStatusBar = NSStatusBar.system
    static var appStatusItem: NSStatusItem!
    static var appStatusItemMenu: NSMenu!
    static var appStatusItemMenuDelegate: NSMenuDelegate!
    
    @StateObject var updaterViewModel = UpdaterViewModel()
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        Settings { EmptyView() }
            .commands {
                CommandGroup(after: .appInfo) {
                    CheckForUpdatesView(updaterViewModel: updaterViewModel)
                }
            }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Paddle stuff
        let myPaddleVendorID = "160105"
        let myPaddleProductID = "800331"
        let myPaddleAPIKey = "f1dc11635b7bcff08ba69753c5590f3b"
        
        // Default Product Config in case we're unable to reach our servers on first run
        let defaultProductConfig = PADProductConfiguration()
        defaultProductConfig.productName = "Worky"
        defaultProductConfig.vendorName = "BetweenFrames"
        
        // Initialize the SDK singleton with the config
        let paddle = Paddle.sharedInstance(
            withVendorID: myPaddleVendorID,
            apiKey: myPaddleAPIKey,
            productID: myPaddleProductID,
            configuration: defaultProductConfig,
            delegate:nil)
        
        // Initialize the Product you'd like to work with
        let paddleProduct = PADProduct(
            productID: myPaddleProductID,
            productType: PADProductType.sdkProduct,
            configuration: defaultProductConfig)
        
        // Ask the Product to get its latest state and info from the Paddle Platform
        paddleProduct?.refresh({ (delta: [AnyHashable : Any]?, error: Error?) in
            // Optionally show the default "Product Access" UI to gatekeep your app
            paddle?.showProductAccessDialog(with: paddleProduct!)
        })
        
        // Set app status item
        WorkyApp.appStatusItem = WorkyApp
            .appStatusBar
            .statusItem(withLength: NSStatusItem.variableLength)
        WorkyApp.appStatusItem.button!.image = NSImage(named: "status-bar-icon")
        WorkyApp.appStatusItem.button!.image!.isTemplate = true
        
        // Set app status item menu
        WorkyApp.appStatusItemMenu = NSMenu(title: "Worky")
        WorkyApp.appStatusItemMenuDelegate = MenuDelegate()
        WorkyApp.appStatusItemMenu.delegate = WorkyApp.appStatusItemMenuDelegate
        WorkyApp.appStatusItem.menu = WorkyApp.appStatusItemMenu
        
    }
}

class MenuDelegate: NSObject, NSMenuDelegate {
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
        
        // Add new workspace
        menu.addItem(
            withTitle: "Add new workspace",
            action: #selector(addNewWorkspace),
            keyEquivalent: "a"
        ).target = self
    
        // MARK: - here i am
        
        // Add import as workspace
        menu.addItem(
            withTitle: "Import as workspace",
            action: #selector(importAsWorkspace),
            keyEquivalent: ""
        ).target = self
        
        menu.addItem(.separator())
        
        // Show workspaces not selected if there are
        let workspaces = WorkyModel.workspaces
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
            
        }
        
        // Show current workspace if there's one
        if WorkyModel.currentWorkspace != nil {
            let workspace = WorkyModel.currentWorkspace!
            
            let menuItem = menu.addItem(
                withTitle: "\(workspace.emoji) \(workspace.title)",
                action: nil,
                keyEquivalent: "")
            
            menuItem.isEnabled = false
            
            menu.addItem(
                withTitle: "Empty",
                action: #selector(emptyDesktop),
                keyEquivalent: "H"
            ).target = self
            
        }
        
        // If there's no workspaces and current, show no workspaces available message
        if WorkyModel.workspaces.count == 0 && WorkyModel.currentWorkspace == nil {
            menu.addItem(
                withTitle: "No workspaces available",
                action: nil,
                keyEquivalent: ""
            )
        }
            
        menu.addItem(.separator())
            
        // Add preferences
        menu.addItem(
            withTitle: "Preferences",
            action: #selector(showPreferencesWindow(sender: <#T##NSMenuItem#>)),
            keyEquivalent: ""
        ).target = self
        
        // Add Quit
        menu.addItem(
            withTitle: "Quit Worky",
            action: #selector(quitApp),
            keyEquivalent: "q"
        ).target = self
    }
    
    // MARK: Create workspace
    @objc func addNewWorkspace() {
        CreateWorkspaceWindow.shared.bringToFront()
    }
    
    // MARK: Import workspace
    @objc func importAsWorkspace() {
        let panel = NSOpenPanel()
        panel.canCreateDirectories = true
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        
        let response = panel.runModal()
        
        guard let importURL = response == .OK ? panel.url : nil else {
            return
        }
        
        let fm = FileManager.default
        
        // If the selected directory doesn't contain a serialization, but
        // there's a directory with the same name inside container already
        // alert.
        //
        // Get path to $HOME/Documents/Worky (WorkyModel.containerURL) and
        // check if the path to the directory contains this path string.
        if importURL.path.contains(WorkyModel.containerURL.path) {
            // TODO: Encapsulate the alert logic and only modify the message
            let alert = NSAlert()
            alert.icon = NSImage(named: "AppIcon")
            alert.messageText = "A directory with the same name already exists in /Documents/Worky, try removing it."
            alert.runModal()
        }
        
        // If workspace already exists
        let workspaces = WorkyModel.workspaces
        
        for workspace in workspaces {
            if workspace.title == importURL.lastPathComponent {
                // This means a directory workspace with the title same
                // as the directory name exists already in the container.
                // - the workspace directory could have a different name as the
                //   imported one, but the serialization title inside this directory
                //   is the same as the imported directory name.
                
                // But it could not have a serialization, and that's why it's not
                // showing in the menu bar.
                
            }
        }
        
        // Move imported directory to container
        do {
            try fm.moveItem(
                at: importURL,
                to: WorkyModel.containerURL.appendingPathComponent(importURL.lastPathComponent)
            )
        } catch {
            let errorMessage = """
            Could not move imported directory to container.
                Imported directory path: \(importURL.path)
                Destination url: \(WorkyModel.containerURL.appendingPathComponent(importURL.lastPathComponent))
                Error: \(error.localizedDescription)
            """
            fatalError(errorMessage)
        }
        
        let newWorkspace = Workspace(
            title: importURL.lastPathComponent,
            emoji: "📦",
            url: WorkyModel.containerURL.appendingPathComponent(importURL.lastPathComponent)
        )
        
        // TODO: This is ambiguous
        // createDirectory will create the directory and the serialization
        // both if needed.
        //
        // if the directory already exists, in this it will, because we moved
        // it, then it'll not create it.
        //
        // then will check for the serialization inside, if needed it'll
        // create it.
        newWorkspace.createDirectoryIfNeeded()
    }

    // MARK: Choose workspace
    @objc func chooseWorkspace(sender: NSMenuItem) {
        let workspace = sender.representedObject as! Workspace;
        workspace.select()
    }
    
    // MARK: Empty desktop
    @objc func emptyDesktop() {
        Workspace.removeWorkspaceFromDesktop()
    }
   
    // MARK: Show preferences window
    @objc func showPreferencesWindow(sender: NSMenuItem) {
        ManageWindow.shared.bringToFront()
    }
    
    // MARK: Quit appplication
    @objc func quitApp() {
        NSApp.terminate(self)
    }
}
