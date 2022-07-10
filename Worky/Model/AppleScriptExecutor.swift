//
//  AppleScriptExecutor.swift
//  Worky
//
//  Created by Kenneth Quintero on 08/07/22.
//

import Foundation

struct AppleScriptExecutor {
    
    @discardableResult
    static func toggleDesktopVisibility() -> (success: Bool, error: NSDictionary?) {
        
        guard let scriptFilePath = Bundle.main.path(
            forResource: "ToggleDesktopVisibility",
            ofType: "scpt")
        else {
            print("apple script file not found")
            return (false, nil)
        }
        
        let contentOfFile = try? String(contentsOfFile: scriptFilePath)
    
        guard let appleScript = contentOfFile else {
            return (false, nil)
        }
        
        var error: NSDictionary?
        
        if let scriptObject = NSAppleScript(source: appleScript) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            
            if error == nil {
                return (output.booleanValue, nil)}
            else {
                return (false, error)}
        }
        
        return (false, error)
    }
}
