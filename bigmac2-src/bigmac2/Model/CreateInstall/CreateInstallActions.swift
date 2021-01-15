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
     
        guard globalDispatch == nil && globalWorkItem == nil else {
            performSegue(withIdentifier: "namedTask", sender: self)
            return
        }

        progressBarDownload.doubleValue = 0
        progressBarDownload.isIndeterminate = false
        
        //MARK: To Do - connect this a backend where we can possibly choose the download OR always download the latest
        downloadMacOSTask(label: "Downloading macOS", urlString: "http://swcdn.apple.com/content/downloads/00/55/001-86606-A_9SF1TL01U7/5duug9lar1gypwunjfl96dza0upa854qgg/InstallAssistant.pkg")
    }

    //MARK: Phase 1.0
    @IBAction func createInstallDisk(_ sender: Any) {
        //Erase a Disk first
        self.performSegue(withIdentifier: "eraseDisk", sender: self)
        
    }
    
    
    //MARK: Download APFS ROM Patcher
    @IBAction func apfsRomDownload(_ sender: Any) {
        dosDude1inProgressTask(label: "Downloading APFS ROM Patcher", dmg: dosDude1DMG)
    }
    
}


