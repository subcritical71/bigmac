//
//  Utilities.swift
//  bigmac2
//
//  Created by starplayrx on 1/1/21.
//

import Cocoa


extension ViewController {
  
    
    @IBAction func LoRes_720(_ sender: Any) {
        _ = runCommandReturnString(binary: setResX, arguments: ["-w", "1280", "-h", "720", "-s", "1"])
    }
    @IBAction func HiRes_720(_ sender: Any) {
        _ = runCommandReturnString(binary: setResX, arguments: ["-w", "1280", "-h", "720", "-s", "2"])
    }
    @IBAction func LoRes_1080(_ sender: Any) {
        _ = runCommandReturnString(binary: setResX, arguments: ["-w", "1920", "-h", "1080", "-s", "1"])
    }
    
    @IBAction func HiRes_1080(_ sender: Any) {
        _ = runCommandReturnString(binary: setResX, arguments: ["-w", "1920", "-h", "1080", "-s", "2"])
    }
    
    func disableSetResXButtonsCheck() {
        if !fm.fileExists(atPath: setResX) {
            LowRes_720.isHidden = true
            HiRes_720.isHidden = true
            LowRes_1080.isHidden = true
            HiRes_1080.isHidden = true
        }
    }
    
    //MARK: Move to Utilities
    func checkIfFileExists(path: String) -> Bool {
        if fm.fileExists(atPath: path) {
            return true
        } else {
            return false
        }
    }

    func checkForBaseOS() -> Bool {
        if fm.fileExists(atPath: baseOS) {
            return true
        } else {
            return false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseBootArgs()
        disableSetResXButtonsCheck()
        bootedToBaseOS = checkForBaseOS()
        
        //MARK: Set Up and AI that knows what tab to do (checks for maybe an unpatch drive or 11.1 presence)
        if ( bootedToBaseOS) {
            tabViews.selectTabViewItem(preInstallTab)
            tabViews.drawsBackground = false
        }
    }
}
