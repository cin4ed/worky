//
//  WorkspaceManager.swift
//  Worky
//
//  Created by Kenneth Quintero on 25/01/25.
//

import SwiftUI

class WorkspaceManager: ObservableObject {
    @Published var currentWorkspace: Workspace?
    @Published var workspaces: [Workspace]
    
    init(currentWorkspace: Workspace, workspaces: [Workspace]) {
        self.currentWorkspace = currentWorkspace
        self.workspaces = workspaces
    }
}
