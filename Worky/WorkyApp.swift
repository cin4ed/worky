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
        WorkyApp.appStatusItemMenuDelegate = MenuDelegate() as NSMenuDelegate
        WorkyApp.appStatusItemMenu.delegate = WorkyApp.appStatusItemMenuDelegate
        WorkyApp.appStatusItem.menu = WorkyApp.appStatusItemMenu
        
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
