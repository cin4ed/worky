//
//  AppPopover.swift
//  Worky
//
//  Created by Kenneth Quintero on 20/01/25.
//

import SwiftUI

/// A class that encapsulates the creation and configuration of an NSPopover.
class AppPopover: NSObject, NSPopoverDelegate {
    /// The underlying `NSPopover` instance.
    private var popover: NSPopover
    
    /// A shared state object for the popover content.
    public var state: PopoverState
    
    /// Initializes a new `AppPopover` with a given content view and state
    ///
    /// - Parameters:
    ///     - contentView: The SwiftUI view to display in the popover
    ///     - state: An `ObservableObject` used to manage the popover's state
    init<Content: View>(contentView: Content, state: PopoverState) {
        self.popover = NSPopover()
        self.state = state
        super.init()
        
        // Configure the popover
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 300, height: 350)
        popover.delegate = self
        popover.contentViewController = NSHostingController(rootView: contentView.environmentObject(state))
    }
    
    /// Toggles the popover relative to the specified view.
    ///
    /// - Parameters:
    ///     - button: The `NSStatusBarButton` relative to which the popover will appear.
    ///     - sender: The object that riggered the toggle action.
    func toggle(relativeTo button: NSStatusBarButton, sender: AnyObject?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    /// Handles the closure of the popover and resets state
    ///
    /// - Parameter notification: The notification sent when the popover closes.
    func popoverDidClose(_ notification: Notification) {
        state.creatingWorkspace = false
    }
}
