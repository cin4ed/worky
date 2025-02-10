//
//  CleanDesktopButton.swift
//  Worky
//
//  Created by Kenneth Quintero on 09/02/25.
//

import SwiftUI

struct CleanDesktopButton: View {
    
    @State private var isHovered = false
    
    var body: some View {
        HStack {
            Text("✨").font(.title)
            Text("Clean Desktop").font(.body)
            Spacer()
        }
        .padding(.horizontal, 5)
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isHovered ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                .animation(.easeInOut(duration: 0.2), value: isHovered)
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    CleanDesktopButton()
}
