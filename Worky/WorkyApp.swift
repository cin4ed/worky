//
//  WorkyApp.swift
//  Worky
//
//  Created by Kenneth Quintero on 28/05/22.
//

import SwiftUI
import AppKit

// Almost all the main logic of the app is inside AppStatusItemMenuDelegate

@main
struct WorkyApp: App {
    
    @StateObject var updaterViewModel = UpdaterViewModel()
    
    @NSApplicationDelegateAdaptor
    private var appDelegate: AppDelegate
    
    static private(set) var shared: WorkyApp!
    
    static private(set) var container: URL!
    static var currentWorkspace: Workspace?
    
    var body: some Scene {
        Settings {}
            .commands {
                CommandGroup(after: .appInfo) {
                    CheckForUpdatesView(updaterViewModel: updaterViewModel)
                }
            }
    }
    
    init() {
        startupLog.info("Application has started.")
        
        WorkyApp.shared = self
        
        let fm = FileManager.default
        
        // Create directory container for workspaces in
        // $HOME/Documents/Worky if needed
        let containerURL = fm
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Documents/Worky")
        
        // Stop execution if can't create the container dir
        do {
            startupLog.info("Creating workspace container at $HOME/Documents/Worky")
            try fm.createDirectory(
                at: containerURL,
                withIntermediateDirectories: true,
                attributes: nil)
        } catch {
            startupLog.error("Could not create workspace container at $HOME/Documents/Worky. Error: \(error.localizedDescription, privacy: .public)")
            fatalError("Couldn't create workspace container at Document/Worky. Error: \(error)")
        }
        
        // If everything went well set the container
        startupLog.info("Setting the container to default location $HOME/Documens/Worky")
        WorkyApp.container = containerURL
        
        // Check if there's a workspace in the desktop directory,
        // if so, set current workspace to this
        startupLog.info("Checking wheter there is a workspace in desktop already.")
        let desktopURL = fm
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Desktop")
        
        // Trying to read the contents of desktop this shouldn't go
        // wrong right? so force unwrap
        guard let desktopContents = try? fm.contentsOfDirectory(
            at: desktopURL,
            includingPropertiesForKeys: nil)
        else {
            startupLog.critical("Could not get the contents of desktop.")
            fatalError("Could not get the contents of desktop.")
        }
        
        for file in desktopContents {
            if file.path.contains(".worky.json") {
                startupLog.info("Workspace found in desktop. Trying to instantiate it.")
                
                guard let workspace = try? Workspace(file: file) else {
                    startupLog.critical("Could not instantiate workspace found in desktop.")
                    fatalError("Could not instantiate workspace found in desktop at startup.")
                }
                
                startupLog.info("Workspace encountered in desktop: \(workspace.title, privacy: .public)")
                
                startupLog.info("Setting current workspace to workspace found in desktop.")
                WorkyApp.currentWorkspace = workspace
                
                break
            }
        }
    }
}
