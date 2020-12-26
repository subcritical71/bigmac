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
    let output = String(data: data, encoding: String.Encoding.utf8)
    print (output!)
    return output
    
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
    
    /* Runn command in the background */
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
                    else { return}
                
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
                
                //let unMountTarget = ["mountDisk", self.disk]
                
                //let mountDisk = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: unMountTarget)
                DispatchQueue.main.async {
                    
                  //  self.statusTextView.string = self.statusTextView.string + mountDisk
                  //  self.statusTextView.string = self.statusTextView.string  + "\n Job Finished."
                }
            }
            
            process.launch()
            process.waitUntilExit()
       // }
    }

}


