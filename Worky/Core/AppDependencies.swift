//
//  AppDependencies.swift
//  Worky
//
//  Created by Kenneth Quintero on 13/02/25.
//

import Foundation
import Sparkle

class AppDependencies {
    
    static var shared: AppDependencies!
    
    let appController: AppController
    let updaterController: SPUStandardUpdaterController
    
    init(appController: AppController, updaterController: SPUStandardUpdaterController) {
        self.appController = appController
        self.updaterController = updaterController
    }
}
