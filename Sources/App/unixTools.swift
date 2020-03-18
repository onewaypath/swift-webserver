//
//  unixTools.swift
//  App
//
//  Created by Alex Young on 3/18/20.
//

import Foundation
func runUnix(_ command: String, commandPath: String = "/bin/", arguments: [String] = []) -> String {
    
    // Create a process (was NSTask on swift pre 3.0)
    let task = Process()
    let path = commandPath + command
    
    // Set the task parameters
    task.launchPath = path
    task.arguments = arguments
    
    // Create a Pipe and make the task
    // put all the output there
    let pipe = Pipe()
    task.standardOutput = pipe
    
    // Launch the task
    task.launch()
    
    // Get the data
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding.utf8)
    
    return (output!)
    
}
