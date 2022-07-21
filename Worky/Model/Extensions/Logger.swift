//
//  OSLog.swift
//  Worky
//
//  Created by Kenneth Quintero on 16/07/22.
//

import os.log

let defaultSubsystem = "net.between.frames"

let startupLog = Logger(
    subsystem: defaultSubsystem,
    category: "startup"
)
