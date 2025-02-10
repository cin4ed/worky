//
//  AppStatusButton.swift
//  Worky
//
//  Created by Kenneth Quintero on 22/01/25.
//

import AppKit

/// A class that encapsulates the creation and configuration of a status bar button in macOS.
///
/// The `AppStatusButton` class provides an easy way to create a status bar button with a customizable image, action and target.
/// It abstracts the setup of the `NSStatusItem` and its associated button, allowing you to focus on handling the button's actions.
class AppStatusButton {
    
    /// The underlying status bar item associated with the button.
    private var statusItem: NSStatusItem
    
    /// The `NSStatusBarButton` associated with the status bar item.
    private(set) var button: NSStatusBarButton
    
    /// Initializes a new status bar button with the specified image, target, and action.
    ///
    /// - Parameters:
    ///     - imageName: The name of the image to display on the status bar button. Deaults to `"status-icon"`.
    ///     - target: The object that will handle the button's action.
    ///     - action: The selector to invoke when the button is clicked.
    ///
    /// - Throws: A runtime error if the status bar button cannot be created.
    init(imageName: String, target: AnyObject, action: Selector) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let createdButton = statusItem.button else {
            fatalError("Failed to create status bar button.")
        }
        
        self.button = createdButton
        let configuration = NSImage.SymbolConfiguration(pointSize: 16.5, weight: .bold, scale: .medium)
        self.button.image = NSImage(systemSymbolName: imageName, accessibilityDescription: nil)?.withSymbolConfiguration(configuration)
        self.button.action = action
        self.button.target = target
    }
    
    /// Returns the `NSStatusBarButton` associated with the status bar item.
    ///
    /// - Returns: The `NSStatusBarButton` that was successfully created.
    func getButton() -> NSStatusBarButton {
        return button
    }
}
