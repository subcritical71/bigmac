//
//  InstallerActions.swift
//  bigmac2
//
//  Created by starplayrx on 12/28/20.
//
import Cocoa


//MARK: Installer Actions
extension ViewController {
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

    //MARK: Phase 1.1
    @objc func gotEraseDisk(_ notification:Notification){
        //Got permission to erase a disk, proceed with disk workflow
        disk(isBeta: false, diskInfo: notification.object as! myVolumeInfo)
    }
    
    @objc func gotCreateDisk(_ notification:Notification){
        print("gotCreateDisk")
    }
}


