//
//  AppDelegate.swift
//  Worky
//
//  Created by Kenneth Quintero on 18/01/25.
//

import SwiftUI

/// The `AppDelegate` manages the lifecycle of the application and sets up the status bar button and popover.
class AppDelegate: NSObject, NSApplicationDelegate {
    /// The status bar button displayed in the macOS menu bar.
    private var appStatusButton: AppStatusButton!
    
    /// The popover that appears when interacting with the status bar button.
    private var appPopover: AppPopover!
    
    /// The sared state object used to manage the popover's content and behavior.
    private var popoverState = PopoverState()
    
    /// Called when the application finishes launching.
    ///
    /// This method initializes the status bar button and the popover, ensuring the app's primary UI components
    /// are set up and ready to use.
    ///
    /// - Parameter notification: A notification that indicates the app has completed launching.
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize the status bar button with the specified image, target and action.
        appStatusButton = AppStatusButton(
            imageName: "square.grid.2x2",
            target: self,
            action: #selector(togglePopover(_:))
        )
        
        /// Initialize the popover with its content view and shared state.
        appPopover = AppPopover(
            contentView: PopoverView(),
            state: popoverState
        )
    }
    
    /// Toggles the visibility of the popover relative to the status bar button
    ///
    /// - Parameter sender: The object that triggered the toggle action.
    @objc private func togglePopover(_ sender: AnyObject?) {
        appPopover.toggle(relativeTo: appStatusButton.button, sender: sender)
    }
}

class PopoverState: ObservableObject {
    @Published var creatingWorkspace: Bool = false
}
