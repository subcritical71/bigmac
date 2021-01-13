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
    
    
    //MARK: Download APFS ROM Patcher
    @IBAction func apfsRomDownload(_ sender: Any) {
        guard globalDispatch == nil && globalWorkItem == nil else {
            performSegue(withIdentifier: "namedTask", sender: self)
            return
        }
        
        
        if let r = Bundle.main.resourceURL?.path, let p  =  Optional(r + "/" + dosDude1DMG), checkIfFileExists(path: p) {
            _ = mountDiskImage(arg: ["mount", "\(p)", "-noverify", "-noautofsck", "-autoopen"])
        } else {
            globalWorkItem = DispatchWorkItem { [self] in downloadDMG(diskImage: dosDude1DMG, webSite: "https://starplayrx.com/bigmac2/") }
            globalDispatch = DispatchQueue(label: "Downloading APFS ROM Patcher")
            
            if let d = globalDispatch, let w = globalWorkItem {
                d.async(execute: w)
            }
        }
    }
    
}


