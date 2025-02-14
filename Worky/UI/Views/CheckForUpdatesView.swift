//
//  CheckForUpdatesView.swift
//  Worky
//
//  Created by Kenneth Quintero on 11/02/25.
//

import SwiftUI
import Sparkle

struct CheckForUpdatesView: View {
    @ObservedObject private var checkForUpdatesViewModel: CheckForUpdatesViewModel
    private let updater: SPUUpdater
    
    init(updater: SPUUpdater) {
        self.updater = updater
        self.checkForUpdatesViewModel = CheckForUpdatesViewModel(updater: updater)
    }
    
    var body: some View {
        Button("Check for Updates...", action: updater.checkForUpdates)
            .disabled(!checkForUpdatesViewModel.canCheckForUpdate)
    }
}

final class CheckForUpdatesViewModel: ObservableObject {
    @Published var canCheckForUpdate = false
    
    init(updater: SPUUpdater) {
        updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdate)
    }
}

//#Preview {
//    CheckForUpdatesView()
//}
