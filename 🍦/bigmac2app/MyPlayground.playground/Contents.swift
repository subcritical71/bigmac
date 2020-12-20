import Cocoa

var str = "Hello, playground"



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

runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["info", "/"])
