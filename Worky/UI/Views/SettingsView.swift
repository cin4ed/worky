//
//  SettingsView.swift
//  Worky
//
//  Created by Kenneth Quintero on 11/02/25.
//

import SwiftUI
import Sparkle

struct SettingsView: View {
    
    var updater: SPUUpdater
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            header
            Divider()
            updateSettingSection
            Divider()
            HStack {
                Spacer()
                Button(action: { NSApp.terminate(self) }) {
                    Text("Quit Worky")
                }
            }
        }
        .padding()
    }
    
    private var header: some View {
        HStack {
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .frame(maxWidth: 75, maxHeight: 75)
            VStack(alignment: .leading, spacing: 4) {
                Text("Worky")
                    .font(.title)
                Text("macOS Desktop Organizer")
                    .font(.callout)
                Text("v0.0.0 (0)")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
        }
    }
    
    private var updateSettingSection: some View {
        VStack(alignment: .leading) {
            Text("Update Preferences")
                .foregroundStyle(.gray)
            VStack(alignment: .leading) {
                UpdaterSettingsView(updater: updater)
                CheckForUpdatesView(updater: updater)
            }.padding(10)
        }
    }
}

#Preview {
    let updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )
    
    SettingsView(updater: updaterController.updater)
        .padding()
        .frame(maxWidth: 500)
}
