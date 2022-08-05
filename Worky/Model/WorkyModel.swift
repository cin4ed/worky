//
//  WorkyModel.swift
//  Worky
//
//  Created by Kenneth Quintero on 04/08/22.
//

import Foundation

class WorkyModel: ObservableObject {
    
    private init() {}
    static let shared = WorkyModel()
    
    @Published var workspaces = Workspace.getAllWorkspacesWithCurrent()
    
    func update() {
        self.workspaces = Workspace.getAllWorkspacesWithCurrent()
        self.objectWillChange.send()
    }
}
