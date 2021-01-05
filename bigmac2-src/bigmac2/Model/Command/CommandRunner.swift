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

        DispatchQueue.main.async {
            self.mediaLabel.stringValue = title
            self.sharedSupportGbLabel.stringValue = ""
            self.sharedSupportProgressBar.doubleValue = 0
            self.sharedSupportPercentage.stringValue = "0%"
        }
        
        //DispatchQueue.global(qos: .background).async {
            let process = Process()
            process.launchPath = binary
            process.arguments = arguments
            
            let pipe = Pipe()
            process.standardOutput = pipe
            process.standardError = pipe
            
            let handler =  { (file: FileHandle!) -> Void in
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
                    
                    //PSTT    0    100    start replicate
                    //self.statusTextView.string = self.statusTextView.string + (output as String)
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
       // }
    }
    
    //MARK: Pseudo Logger to estimate time stamp size
    func fakeLogger(format: String, pname: String) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS.mmm.mmmm"
        let timestamp = fmt.string(from: NSDate() as Date)

        let pinfo = ProcessInfo()
        let pid = pinfo.processIdentifier
        var tid = UInt64(0)
        pthread_threadid_np(nil, &tid)

        return "\(timestamp) \(pname)[\(pid):\(tid)]"
    }
    
    /* Run command in the background */
    func runIndeterminateProcess(binary: String, arguments: [String], title: String, sleepForHeadings: Bool = false) {
        
        //MARK: Used to get a count for kmutil prefix
        ///Used to strip out time stamps from the GUI outout as it's not relevant and takes up a lot of real estate.
        let pre = fakeLogger(format: "", pname: "kmutil").count

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
            
            let handler =  { (file: FileHandle!) -> Void in
                let data = file.availableData
                guard let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    else { return }
                
                DispatchQueue.main.async { [self] in
                    
                    var str = String(output)
                    
                    str = str.replacingOccurrences(of: "\t", with: "")
                    str = str.replacingOccurrences(of: "\r", with: "")
                    str = str.replacingOccurrences(of: "\n", with: " ")
                    str = str.replacingOccurrences(of: "      ", with: " ")
                    str = str.replacingOccurrences(of: "     ", with: " ")
                    str = str.replacingOccurrences(of: "    ", with: " ")
                    str = str.replacingOccurrences(of: "   ", with: " ")
                    str = str.replacingOccurrences(of: "  ", with: " ")

                    if (!str.isEmpty || str.count > 6 || str != "") && !str.contains("  ") {
                        self.postInstallTask_label.stringValue = str as String
                    }
                }
            }
        
            let handler2 = { (file: FileHandle! ) -> Void in
                let data = file.availableData
                guard let output2 = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    else { return }
                
                DispatchQueue.main.async { [self] in
                    var fix = String(output2) as String
                    fix = String(fix.prefix(pre))
                    let io = String(output2).deletingPrefix(fix)
                                        
                    if !String(io).isEmpty && !String(io).contains("kmutil") && (String(io).contains("alidating") || String(io).contains("riting")) {
                        self.postInstallDetails_label.stringValue = io as String
                    }
                    
                }
            }
            
            pipe.fileHandleForReading.readabilityHandler = handler
            pipe2.fileHandleForReading.readabilityHandler = handler2

            //Finish the Job
            process.terminationHandler = { (task: Process?) -> () in
                pipe.fileHandleForReading.readabilityHandler = nil
                
                DispatchQueue.main.async { [self] in
                    postInstallFuelGauge.doubleValue += 1
                    postInstallProgressIndicator.doubleValue += 1
                }
            }
            
            process.launch()
            process.waitUntilExit()
       // }
    }

}


extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
