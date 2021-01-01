//
//  InstallerActions.swift
//  bigmac2
//
//  Created by starplayrx on 12/28/20.
//
import Cocoa


//MARK: Installer Actions
extension ViewController {
    
    @IBAction func baseVerboseAction(_ sender: Any) {
        verboseUserCheckbox.state == .on ? (isBaseVerbose = true) : (isBaseVerbose = false)
    }

    
    @IBAction func baseSingleUserAction(_ sender: Any) {
        singleUserCheckbox.state == .on ? (isBaseSingleUser = true) : (isBaseSingleUser = false)
    }
    
    @IBAction func downloadMacOSAction(_ sender: Any) {
        progressBarDownload.doubleValue = 0
        progressBarDownload.isIndeterminate = false
        downloadPkg()
    }

    //MARK: Phase 1.0
    @IBAction func createInstallDisk(_ sender: Any) {
        //Erase a Disk first
        self.performSegue(withIdentifier: "eraseDisk", sender: self)
    }
    
    
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
}


