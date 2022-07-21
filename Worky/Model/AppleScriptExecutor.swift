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
        appleScriptLog.info("Toggle desktop visibility triggered.")
        
        appleScriptLog.info("Getting script file from bundle.")
        guard let scriptFilePath = Bundle.main.path(
            forResource: "ToggleDesktopVisibility",
            ofType: "scpt")
        else {
            appleScriptLog.error("Could not find ToggleDesktopVisibility.scpt in Bundle.")
            return (false, nil)
        }
        appleScriptLog.info("Script file found and returned succesfully.")
        
//        let contentOfFile = try? String(contentsOfFile: scriptFilePath)
//
//        guard let appleScript = contentOfFile else {
//            return (false, nil)
//        }
        
        appleScriptLog.info("Trying to read the contents of the script file.")
        guard let appleScript = try? String(contentsOfFile: scriptFilePath) else {
            appleScriptLog.error("Could not read the contents of the script file.")
            return (false, nil)
        }
        appleScriptLog.info("Contents read succesfully.")
        
        var error: NSDictionary?
        
        appleScriptLog.info("Trying to instantiate NSAppleScript with script file.")
        if let scriptObject = NSAppleScript(source: appleScript) {
            appleScriptLog.info("Instantiation successfully.")
            
            appleScriptLog.info("Executing script.")
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            appleScriptLog.info("Script executed succesfully.")
            
            if error == nil {
                return (output.booleanValue, nil)}
            else {
                return (false, error)}
        } else {
            
            appleScriptLog.error("Could not instantiate NSAppleScript with script file.")
            return (false, error)
        }
    }
}
