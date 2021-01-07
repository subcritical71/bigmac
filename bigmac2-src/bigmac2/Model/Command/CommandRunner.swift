//
//  CommandRunner.swift
//  bigmac2
//
//  Created by starplayrx on 12/19/20.
//

// #!/usr/bin/env xcrun swift

import Foundation

func runCommandReturnString(binary: String, arguments: [String]) -> String? {
    
    let task = Process()
    if #available(OSX 10.13, *) {
        task.executableURL = URL(string: "file://" + binary)
    } else {
        // Fallback on earlier versions
        task.launchPath = binary
        
    }
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.launch()
    task.waitUntilExit()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    
    if let output = String(data: data, encoding: String.Encoding.utf8), !output.isEmpty {
        print(output)
        return output
    }
    
    return ""
}


/* May remove AppleScript, or keep if for non-root mode*/
func performAppleScript (script: String) -> (text: String?, error: NSDictionary?) {
    
    var text : String?
    var error : NSDictionary?
    
    if let script = NSAppleScript(source: script) {
        let result = script.executeAndReturnError(&error) as NSAppleEventDescriptor
        text = result.stringValue
    }
    
    return (text: text, error: error)
}


extension ViewController {
    
    /* Run command in the background */
    func runProcess(binary: String, arguments: [String], title: String) {
        
        DispatchQueue.main.async { [self] in
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false, cylon: false, title: title)
            sharedSupportGbLabel.stringValue = ""
            sharedSupportProgressBar.doubleValue = 0
            sharedSupportPercentage.stringValue = "0%"
        }
        
        //DispatchQueue.global(qos: .background).async {
        let process = Process()
        process.launchPath = binary
        process.arguments = arguments
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        let handler =  { (file: FileHandle) -> Void in
            let data = file.availableData
            guard let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            else { return }
            
            DispatchQueue.main.async {
                let t = output.components(separatedBy: "\t")
                
                if t.count >= 4 && t.count <= 5 {
                    
                    if let x = Int(t[1]) {
                        if x >= 0 && x <= 100 {
                            self.sharedSupportProgressBar.doubleValue = Double(x)
                            self.sharedSupportPercentage.stringValue = "\(x)%"
                        }
                    }
                }
            }
        }
        
        pipe.fileHandleForReading.readabilityHandler = handler
        
        //Finish the Job
        process.terminationHandler = { (task: Process?) -> () in
            pipe.fileHandleForReading.readabilityHandler = nil
            
            DispatchQueue.main.async {
                //do something
            }
        }
        
        process.launch()
        process.waitUntilExit()
    }
    
    /* Run command in the background */
    func runIndeterminateProcess(binary: String, arguments: [String], title: String, sleepForHeadings: Bool = false) {
        
        DispatchQueue.main.async { [self] in
            postInstallTask_label.stringValue = title
            postInstallDetails_label.stringValue = ""
        }
        
        if sleepForHeadings {
            sleep(2)
        }
        
        //DispatchQueue.global(qos: .background).async {
        let process = Process()
        process.launchPath = binary
        process.arguments = arguments
        
        let pipe = Pipe()
        let pipe2 = Pipe()
        
        process.standardOutput = pipe
        process.standardError = pipe2
  
        let outHandle  = pipe.fileHandleForReading
        let outHandle2 = pipe2.fileHandleForReading
        
        outHandle.readabilityHandler = { pipe in
            if var str = String(data: pipe.availableData, encoding: .utf8) {
                
                str = str.replacingOccurrences(of: "\t", with: "")
                str = str.replacingOccurrences(of: "\r", with: "")
                str = str.replacingOccurrences(of: "\n", with: " ")
                str = str.replacingOccurrences(of: "      ", with: " ")
                str = str.replacingOccurrences(of: "     ", with: " ")
                str = str.replacingOccurrences(of: "    ", with: " ")
                str = str.replacingOccurrences(of: "   ", with: " ")
                str = str.replacingOccurrences(of: "  ", with: " ")
                str = str.capitalized
                
                
                DispatchQueue.main.async { [self] in
                    if (!str.isEmpty) {
                        self.postInstallTask_label.stringValue = str as String
                    }
                }
            }
        }
        
        outHandle2.readabilityHandler = { pipe2 in
            if var io = String(data: pipe2.availableData, encoding: .utf8) {
                
                if io.contains("ting") {
                    io = io.stringAfter("]")
                    io = io.stringAfter(" ")
                    io = io.capitalizingFirstLetter()
                    if (!io.isEmpty) {
                        
                        DispatchQueue.main.async { [self] in
                            self.postInstallDetails_label.stringValue = io as String
                        }
                    }
                }
                
                
            }
        }
        
        
        //Finish the Job
        process.terminationHandler = { (task: Process?) -> () in
            pipe.fileHandleForReading.readabilityHandler = nil
            pipe.fileHandleForReading.readabilityHandler = nil
            
        }
        
        process.qualityOfService = .userInteractive
        process.launch()
        process.waitUntilExit()
    }
}



