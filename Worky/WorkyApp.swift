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
    
    @NSApplicationDelegateAdaptor
    private var appDelegate: AppDelegate
    
    static private(set) var shared: WorkyApp!
    
    static private(set) var container: URL!
    static var currentWorkspace: Workspace!
    
    var body: some Scene {
        Settings {}
    }
    
    init() {
        
        WorkyApp.shared = self
        
        // Create directory container for workspaces in
        // $HOME/Documents/Worky if needed
        let fm = FileManager.default
        
        let containerURL = fm
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Documents/Worky")
        
        // Stop execution if can't create the container dir
        try! fm.createDirectory(
            at: containerURL,
            withIntermediateDirectories: true,
            attributes: nil)
        
        // Set the container
        WorkyApp.container = containerURL
        
        // Check if there's a workspace in the desktop directory,
        // if so, set current workspace to this
        let desktopURL = fm
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Desktop")
        
        let desktopContents = try! fm.contentsOfDirectory(
            at: desktopURL, includingPropertiesForKeys: nil)
         
        for file in desktopContents {
            if file.path.contains(".worky.json") {
                let workspace = try! Workspace(file: file)
                WorkyApp.currentWorkspace = workspace
                break
            }
        }
    }
}
