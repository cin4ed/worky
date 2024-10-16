//
//  WorkyApp.swift
//  Worky
//
//  Created by Kenneth Quintero on 28/05/22.
//

import SwiftUI
import AppKit
import Sparkle

@main
struct WorkyApp: App {
    static let updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    
    // The app's lifecycle is managed through the AppDelegate class, which
    // allows you to set up the status bar item without a main window.
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate;
    
    var body: some Scene {
        // This prevents the app from creating a main window. The app will
        // run as a status bar-only application.
        Settings {
            EmptyView()
        }
    }
}


