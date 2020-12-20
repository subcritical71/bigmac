//
//  CommandRunner.swift
//  bigmac2
//
//  Created by starplayrx on 12/19/20.
//

// #!/usr/bin/env xcrun swift

import Foundation

func runCommandReturnString(binary: String, arguments: [String]) -> String {
    
    let task = Process()
    task.launchPath = binary
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.launch()
    task.waitUntilExit()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output =  String(data: data, encoding: String.Encoding.utf8)!
    
    return output
    
}
