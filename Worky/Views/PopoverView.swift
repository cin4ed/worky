//
//  PopoverView.swift
//  Worky
//
//  Created by Kenneth Quintero on 20/01/25.
//

import SwiftUI

struct PopoverView: View {
    @EnvironmentObject var popoverState: PopoverState
    
    var body: some View {
        Group {
            if !popoverState.creatingWorkspace {
                MainView(onCreateNew: {
                    withAnimation {
                        popoverState.creatingWorkspace = true
                    }
                }).transition(.move(edge: .leading).combined(with: .opacity))
            } else {
                CreateView(onCancel: {
                    withAnimation {
                        popoverState.creatingWorkspace = false
                    }
                }).transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(10)
    }
}

#Preview {
    PopoverView()
}
