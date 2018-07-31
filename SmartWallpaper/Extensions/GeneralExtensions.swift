//
//  GeneralExtensions.swift
//  SmartWallpaper
//
//  Created by Joni Van Roost on 30/07/18.
//  Copyright © 2018 Joni Van Roost. All rights reserved.
//

import Foundation

/// This function is used to execute shell commands.
internal func shell(arguments: [String] = []) -> (String? , Int32) {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.launch()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)
    let terminationStatus = task.terminationStatus
    return (output, terminationStatus)
}
