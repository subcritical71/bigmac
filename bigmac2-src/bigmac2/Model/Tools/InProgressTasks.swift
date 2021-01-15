//
//  InProgressTasks.swift
//  bigmac2
//
//  Created by starplayrx on 1/14/21.
//

import Foundation

//MARK: In Progess Flow
extension ViewController {
    
    func cancelTask() -> Bool {
        guard globalDispatch == nil && globalWorkItem == nil else {
            performSegue(withIdentifier: "namedTask", sender: self)
            return true
        }
        
        return false
    }

    func que(label: String, function: () ) {
        
        globalWorkItem = DispatchWorkItem { function }
        globalDispatch = DispatchQueue(label: label)
        
        if let d = globalDispatch, let w = globalWorkItem {
            d.async(execute: w)
        }
    }
   
    func dosDude1inProgressTask(label: String, dmg: String) {
        if cancelTask() { return }
        
        if let r = Bundle.main.resourceURL?.path, let p  =  Optional(r + "/" + dmg), checkIfFileExists(path: p) {
            _ = mountDiskImage(arg: ["mount", "\(p)", "-noverify", "-noautofsck", "-autoopen"])
        } else {
            let function: () = downloadDMG(diskImage: dmg, webSite: globalWebsite).self
            que(label: label, function: function)
        }
    }
    
    
    func bigMacDataPatchDMG(label: String = "Downloading BigData Patches", dmg: String = bigDataDMG) {
        if cancelTask() { return }
        
        if NSUserName() == "root", let r = Bundle.main.resourceURL?.path, let p = Optional(r + "/" + bigDataDMG), checkIfFileExists(path: p) {
            mountBigData()
        } else if NSUserName() == "root" {
            let function: () = downloadDMG(diskImage: bigDataDMG, webSite: globalWebsite).self
            que(label: label, function: function)
        }
    }
    

    func downloadMacOSTask(label: String = "Downloading macOS", urlString: String = "http://swcdn.apple.com/content/downloads/00/55/001-86606-A_9SF1TL01U7/5duug9lar1gypwunjfl96dza0upa854qgg/InstallAssistant.pkg") {
        if cancelTask() { return }
        
        let function: () = downloadPkg(pkgString : urlString).self
        que(label: label, function: function)
    }
    
    
    
     //MARK: Phase 1.1
     @objc func EraseDisk(_ notification:Notification){


        volumeInfo = notification.object as? myVolumeInfo ?? myVolumeInfo(diskSlice: "", disk: "", displayName: "", volumeName: "", path: "", uuid: "", external: false, root: false, capacity: 0)
      
        DispatchQueue.main.async { [self] in
            spinnerAnimation(start: true, hide: false)
        }
        
        let path = "/Users/shared/\(bigmacDMG)"
        
        if !checkIfFileExists(path: path) {
            
            if cancelTask() { return }

            let function: () =  downloadBigMac2(dmg:"https://\(domain)/\(bigmac2)/\(bigmacDMG)")
            que(label: "Downloading Boot disk", function: function)
            
        } else {
            installDisk()
        }
     }
    
    
    func installDisk() {
        DispatchQueue.main.async { [self] in
            isBaseSingleUser = singleUserCheckbox.state == .on
            isBaseVerbose = verboseUserCheckbox.state == .on
            spinnerAnimation(start: true, hide: false)
        }
     
        //MARK: Internal - To do (Cleanup so it can be used as a backup)
        //disk2(isBeta: false, diskInfo: volumeInfo, isVerbose: isBaseVerbose, isSingleUser: isBaseSingleUser, fullDisk: false) //to do add 3 Xtra steps for production
        
        //Customer
        customerInstallDisk(isBeta: false, diskInfo: volumeInfo, isVerbose: isBaseVerbose, isSingleUser: isBaseSingleUser, fullDisk: true) //not fulldisk is for internal testing
    }
    
     //MARK: Phase 1.2
     @objc func CreateDisk(_ notification:Notification){
        installDisk()
     }
        
}


