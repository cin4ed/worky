//
//  App.swift
//  Worky
//
//  Created by Kenneth Quintero on 02/02/25.
//

import SwiftUI

final class App: NSObject, NSApplicationDelegate {
    
    private var appStatusButton: AppStatusButton!
    private var appPopover: AppPopover!
    private var onboardingWindow: NSWindow?
    
    /// Called when the application finishes launching.
    ///
    /// This method initializes the status bar button and the popover, ensuring the app's primary UI components
    /// are set up and ready to use.
    ///
    /// - Parameter notification: A notification that indicates the app has completed launching.
    func applicationDidFinishLaunching(_ notification: Notification) {
        Container.shared.create()
        
        // Initialize the status bar button with the specified image, target and action
        appStatusButton = AppStatusButton(
            imageName: "square.grid.2x2",
            target: self,
            action: #selector(togglePopover(_:))
        )
    }
    
    /// Toggles the visibility of the popover relative to the status bar button
    ///
    /// - Parameter sender: The object that triggered the toggle action.
    @objc private func togglePopover(_ sender: AnyObject?) {
        makeEveryDirectoryInContainerAWorkspaceExceptForCurrent()
        
//         Refresh the content view every time the popover is toggled
        appPopover = AppPopover(
            contentView: PopoverView(
                onCreateWorkspace: createWorkspace,
                onChooseWorkspace: chooseWorkspace
            )
        )
    
        
        appPopover.toggle(relativeTo: appStatusButton.button, sender: sender)
    }
    
    // MARK: - Create And Choose Workspace
    
    private func presentWorkspaceExistsAlert() {
        let alert = NSAlert()
        alert.messageText = "A workspace with the same name already exists"
        alert.runModal()
    }
    
    func createWorkspace(name: String, emoji: String) {
        let workspace = Workspace(name: name, emoji: emoji)
        
        if Container.shared.directoryExists(workspace.name) {
            presentWorkspaceExistsAlert()
            return
        }
        
        chooseWorkspace(workspace)
    }
    
    func chooseWorkspace(_ workspace: Workspace) {
        let desktop = Desktop.shared
        let container = Container.shared
        
        if desktop.currentWorkspace == workspace {
            return
        }
        
        var mutableWorkspace = workspace // Create a mutable copy
        
        if mutableWorkspace.directory == nil || !container.directoryExists(mutableWorkspace.directory!) {
            do {
                mutableWorkspace.directory = try mutableWorkspace.createDirectory(at: container.directory)
                try mutableWorkspace.saveAsJSON(at: mutableWorkspace.directory!)
            } catch {
                // Handle the error, e.g., show an alert
                print("Error creating or saving workspace: \(error)")
                return // Exit early if we can't create the directory.
            }
        }
        
        if var currentWorkspace = desktop.currentWorkspace {
            if !container.directoryExists(currentWorkspace.directory!) {
                do {
                    currentWorkspace.directory = try currentWorkspace.createDirectory(at: container.directory)
                } catch{
                    // Handle the error, e.g., show an alert
                    print("Error creating current workspace directory: \(error)")
                }
            }
            desktop.moveContents(to: currentWorkspace.directory!)
        }
        
        do {
            try mutableWorkspace.moveContents(to: desktop.directory)
        } catch {
            // Handle the error
            print("Error moving contents to desktop: \(error)")
        }
        
        appPopover.close()
    }
    
    // for every directory in container that is not a workspace or the directory name does not match workspace name do:
    func makeEveryDirectoryInContainerAWorkspaceExceptForCurrent() {
        for url in Container.shared.getContents() {
            // If it's not a directory skip it
            guard FileManager.default.isDirectory(url) else {
                continue
            }
            
            // If directory is not a workspace then convert it
            guard var workspace = try? Workspace(from: url) else {
                
                // If the directory has the same name as the current workspace, then continue
                guard Desktop.shared.currentWorkspace?.name != url.lastPathComponent else  {
                    continue
                }
                
                var newWorkspace = Workspace(name: url.lastPathComponent)
                newWorkspace.directory = url
                try! newWorkspace.saveAsJSON(at: url)
                
                continue
            }
            
            // Lastly if directory is a workspace but, the workspace name doesn't
            // match the directory one, then update workspace name to match directory
            if workspace.name != url.lastPathComponent {
                workspace.name = url.lastPathComponent
                workspace.directory = url
                try! workspace.saveAsJSON(at: url)
            }
        }
    }
}

// MARK: - Onboarding

//extension App {
//    func onOnboardingCancelled() {
//
//    }
//
//    func onOnboardingCompleted() {
//        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
//
//        // Reset onboarding flag on development
//#if DEBUG
//        UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
//#endif
//
//        if onboardingWindow != nil {
//            onboardingWindow!.close()
//            onboardingWindow = nil
//        }
//    }
//
//    private func showOnboardingIfApplies() {
//        // If user has seen onboading skip this
//        guard !UserDefaults.standard.bool(forKey: "hasSeenOnboarding") else { return }
//
//        // Create a window to host the onboarding view
//        let window = NSWindow(
//            contentRect: NSRect(x: 0, y: 0, width: 500, height: 250),
//            styleMask: [.titled, .closable],
//            backing: .buffered,
//            defer: false
//        )
//        window.center()
//        window.title = "Worky"
//        window.makeKeyAndOrderFront(nil)
//
//        let onboarding = NSHostingView(
//            rootView: OnboardingView(onCancel: onOnboardingCancelled, onboardingCompleted: onOnboardingCompleted))
//
//        window.contentView = onboarding
//
//        self.onboardingWindow = window
//
//        // ✅ Block execution until the window is dismissed
//        NSApp.runModal(for: window)
//    }
//}
