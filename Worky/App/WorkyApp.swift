//
//  WorkyApp.swift
//  Worky
//
//  Created by Kenneth Quintero on 02/02/25.
//

import SwiftUI
import Sparkle

@main
struct WorkyApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
//    private let updaterController: SPUStandardUpdaterController
    
    init() {
        // Initialize Sparkle Updater Controller
//        updaterController = SPUStandardUpdaterController(
//            startingUpdater: true,
//            updaterDelegate: nil,
//            userDriverDelegate: nil
//        )
        let containerDirectoryURL = FileManager
            .default
            .homeDirectoryForCurrentUser
            .appendingPathComponent(".worky")
        
        let desktopDirectoryURL = FileManager
            .default
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Desktop")
        
        let appController = AppController(
            container: Container(directory: containerDirectoryURL),
            desktop: Desktop(directory: desktopDirectoryURL)
        )
        
        let updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )

        AppDependencies.shared = AppDependencies(
            appController: appController,
            updaterController: updaterController
        )
    }
    
    var body: some Scene {
        Settings {
            Text("Unavailable")
        }
    }
}

//struct LegacyAppDelegateWrapper {
//    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//}
//
//@main
//struct WorkyApp: App {
//    
//    private let legacyAppDelegate: LegacyAppDelegateWrapper?
//    private let updaterController: SPUStandardUpdaterController
//    private let appController: AppController?
//
//    init() {
//        updaterController = SPUStandardUpdaterController(
//            startingUpdater: true,
//            updaterDelegate: nil,
//            userDriverDelegate: nil
//        )
//        
//        if #available(macOS 13, *) {
//            legacyAppDelegate = nil // Skip AppDelegate initialization
//            let containerDirectoryURL = FileManager.default.homeDirectoryForCurrentUser
//                .appendingPathComponent(".worky")
//            let desktopDirectoryURL = FileManager.default.homeDirectoryForCurrentUser
//                .appendingPathComponent("Desktop")
//            appController = AppController(
//                container: Container(directory: containerDirectoryURL),
//                desktop: Desktop(directory: desktopDirectoryURL)
//            )
//        } else {
//            legacyAppDelegate = LegacyAppDelegateWrapper() // Initialize only for macOS < 13
//            appController = nil
//        }
//    }
//
//    var body: some Scene {
//        if #available(macOS 13, *) {
//            MenuBarExtra {
//                MainView(appController!)
//            } label: {
//                Image(systemName: "star.fill")
//            }.menuBarExtraStyle(.window)
//        }
//        Settings {
//            Text("Unavailable")
//        }
//    }
//}
