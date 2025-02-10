//
//  main.swift
//  Worky
//
//  Created by Kenneth Quintero on 23/01/25.
//

import SwiftUI

/// The main entry point of the macOS application.
///
/// This code sets up the application delegate, configures the app's activation policy,
/// and starts the application lifecycle.

let app = NSApplication.shared

/// Initialize and setup worky, this class also acts as the ApplicationDelegate
let workyApp = App()

/// Assign the `AppDelegate` instance as the delegate for the `NSApplication` instance.
/// This step ensures that the app delegate will receive lifecycle events and manage the app's behavior.
app.delegate = workyApp

/// Set the activation policy of the application to `.prohibited`, this configures the  app to run in the
/// background with no Dock icon or app menu.
app.setActivationPolicy(.prohibited)

/// Start the main application loop. This function initializes the app's event-handling infrastructure and
/// begins processing events.
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
