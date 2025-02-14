//
//  OnboardingView.swift
//  Worky
//
//  Created by Kenneth Quintero on 02/02/25.
//

import SwiftUI

struct OnboardingView: View {
    var onCancel: () -> Void
    var onboardingCompleted: () -> Void
    
    @State private var requestedDesktopAccess = false
    
    @AppStorage("hasGrantedDesktopAccess")
    var hasGrantedDesktopAccess: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 50))
                VStack(alignment: .leading, spacing: 5) {
                    Text("Welcome to Worky")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Grant the necessary permissions to continue.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            Divider()
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Allow access to the desktop directory")
                        Text("Grant the necessary permissions to continue.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    if (requestedDesktopAccess) {
                        Button(action: {}) {
                            Text("Granted")
                        }
                        .disabled(true)
                    } else {
                        Button(action: requestDesktopAccess) {
                            Text("Request Access")
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            
            Divider()
            HStack {
                Spacer()
                Button(action: onCancel) {
                    Text("Cancel")
                }
                // Continue Button
                Button(action: onboardingCompleted) {
                    Text("Continue")
                }
                .disabled(!requestedDesktopAccess)
                .padding(.horizontal, 16)
            }
            
        }
        .padding(30)
    }
    
    private func requestDesktopAccess() {
        let desktopURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop")

        let openPanel = NSOpenPanel()
        openPanel.title = "Grant Access to Your Desktop"
        openPanel.message = "Please select your Desktop folder to grant access."
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.directoryURL = desktopURL
        openPanel.prompt = "Grant Access"

        let response = openPanel.runModal()
        
        guard response == .OK, let selectedURL = openPanel.url else {
            print("❌ User canceled or no valid directory selected.")
            return
        }

        // Ensure that the user selected the Desktop folder.
        if selectedURL.standardizedFileURL != desktopURL.standardizedFileURL {
            print(desktopURL)
            print(FileManager.SearchPathDirectory.desktopDirectory)
            print(selectedURL)
            print("❌ The selected folder is not the Desktop directory.")
            return
        }

        // Start accessing the security-scoped resource.
        if selectedURL.startAccessingSecurityScopedResource() {
            defer { selectedURL.stopAccessingSecurityScopedResource() } // Ensure it is released properly.

            // ✅ Persist the access by saving a security-scoped bookmark.
            do {
                let bookmarkData = try selectedURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                UserDefaults.standard.set(bookmarkData, forKey: "desktopBookmark") // Store the bookmark
                hasGrantedDesktopAccess = true // ✅ Update @AppStorage variable
                requestedDesktopAccess = true  // ✅ Update local state
            } catch {
                print("❌ Failed to create security-scoped bookmark: \(error)")
            }
        } else {
            print("❌ Failed to start accessing security-scoped resource.")
        }
    }
}

#Preview {
    OnboardingView(onCancel: {}, onboardingCompleted: {})
        .padding()
}
