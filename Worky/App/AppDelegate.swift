//
//  AppDelegate.swift
//  Worky
//
//  Created by Kenneth Quintero on 11/02/25.
//

import SwiftUI

class AppDelegate : NSObject, NSApplicationDelegate {
    
    private var appStatusButton: AppStatusBarButton!
    private var appPopover: AppPopover!
    private var appController: AppController
    
    override init() {
        // Setup the application controller
//        let containerDirectoryURL = FileManager
//            .default
//            .homeDirectoryForCurrentUser
//            .appendingPathComponent(".worky")
//        
//        let desktopDirectoryURL = FileManager
//            .default
//            .homeDirectoryForCurrentUser
//            .appendingPathComponent("Desktop")
//        
//        appController = AppController(
//            container: Container(directory: containerDirectoryURL),
//            desktop: Desktop(directory: desktopDirectoryURL)
//        )
        appController = AppDependencies.shared.appController
    }
    
    /// Called when the application finishes launching.
    ///
    /// This method initializes the status bar button and the popover, ensuring the app's primary UI components
    /// are set up and ready to use.
    ///
    /// - Parameter notification: A notification that indicates the app has completed launching.
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize the status bar button with the specified image, target and action
        appStatusButton = AppStatusBarButton(
            imageName: "square.grid.2x2",
            target: self,
            action: #selector(togglePopover(_:))
        )
        
        appController.onChoosedWorkspace({
            self.appPopover.close()
        })
    }
    
    /// Toggles the visibility of the popover relative to the status bar button
    ///
    /// - Parameter sender: The object that triggered the toggle action.
    @objc private func togglePopover(_ sender: AnyObject?) {
        appController.makeEveryDirectoryInContainerAWorkspaceExceptForCurrent()
        
        // Refresh the content view every time the popover is toggled
        appPopover = AppPopover(contentView: MainView(appController))
        
        appPopover.toggle(relativeTo: appStatusButton.button, sender: sender)
    }
}
