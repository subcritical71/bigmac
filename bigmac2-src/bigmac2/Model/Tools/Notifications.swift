//
//  View.swift
//  bigmac2
//
//  Created by starplayrx on 12/28/20.
//

import Cocoa

//MARK: Notification Extensions
extension Notification.Name {
    static let EraseDisk = Notification.Name("EraseDisk")
    static let CreateDisk = Notification.Name("DownloadBigMacDisk")
    static let RunAsRootRequest = Notification.Name("RunAsRootRequest")
    static let Runner = Notification.Name("Runner")
}

//MARK: Notfications Actions
extension ViewController {
    
     //MARK: Phase 1.1
     @objc func EraseDisk(_ notification:Notification){
        volumeInfo = notification.object as? myVolumeInfo ?? myVolumeInfo(diskSlice: "", disk: "", displayName: "", volumeName: "", path: "", uuid: "", external: false, root: false, capacity: 0)
      
        DispatchQueue.main.async { [self] in
            spinnerAnimation(start: true, hide: false)
        }
        
        let path = "/Users/shared/\(bigmacDMG)"
        
        if !checkIfFileExists(path: path) {
            downloadBigMac2(dmg:"https://\(domain)/\(bigmac2)/\(bigmacDMG)")
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
    
    //MARK: Phase 1.2
    @objc func RunAsRootRequest(_ notification:Notification){
        
        let pw = notification.object as? String ?? ""

        //MARK: runs our app as root, pretty sweet
        let bigMacApp = Bundle.main.bundlePath
        runCommand(binary: "\(bigMacApp)/Contents/Resources/bm2" , arguments: [ "\(bigMacApp)/Contents/MacOS/bigmac2", pw ])
        exit(0)
    }

}


//MARK: Load Notifications - Add Observers
extension ViewController {
        
    override func viewDidAppear() {
        let notifications = NotificationCenter.default

        notifications.addObserver(self, selector: #selector(EraseDisk), name: .EraseDisk, object: nil)
        notifications.addObserver(self, selector: #selector(CreateDisk), name: .CreateDisk, object: nil)
        notifications.addObserver(self, selector: #selector(RunAsRootRequest), name: .RunAsRootRequest, object: nil)
        
        if NSUserName() != root {
            performSegue(withIdentifier: "userNamePassWord", sender: nil)
        }
    }
}


