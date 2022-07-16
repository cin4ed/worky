//
//  AppStatusItemMenu.swift
//  Worky
//
//  Created by Kenneth Quintero on 08/07/22.
//

import Foundation
import AppKit

class AppStatusItemMenu: NSMenu {
    
    init() {
        super.init(title: "Worky")
        self.delegate = AppStatusItemMenuDelegate.shared
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder: \(coder) has not been implemented")
    }
}
