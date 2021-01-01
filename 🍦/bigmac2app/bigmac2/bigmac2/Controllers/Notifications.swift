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
    static let RunAtRootRequest = Notification.Name("RunAtRootRequest")
    static let Runner = Notification.Name("Runner")

}


//MARK: Notfications Actions
extension ViewController {
    
     //MARK: Phase 1.1
     @objc func EraseDisk(_ notification:Notification){
        
         volumeInfo = notification.object as! myVolumeInfo //Store in a global

        // permission to erase a disk, proceed with download of BigMacII disk then Create disk workflow
        downloadBigMac2(dmg:"https://www.starplayrx.com/bigmac2/bigmac2.dmg")
        
        DispatchQueue.main.async { [self] in
            spinnerAnimation(start: true, hide: false)
        }
     }

     //MARK: Phase 1.2
     @objc func CreateDisk(_ notification:Notification){

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
    @objc func RunAtRootRequest(_ notification:Notification){
        
        //runs out app as root, pretty sweet
        let bigMacApp = Bundle.main.bundlePath
        _ = runCommandReturnString(binary: "\(bigMacApp)/Contents/Resources/bm2" , arguments: ["\(bigMacApp)/Contents/MacOS/bigmac2", passWord]) ?? ""
        exit(0)
    }

}


//MARK: Load Notifications - Add Observers
extension ViewController {
        
    override func viewDidAppear() {
        let notifications = NotificationCenter.default

        notifications.addObserver(self, selector: #selector(EraseDisk), name: .EraseDisk, object: nil)
        notifications.addObserver(self, selector: #selector(CreateDisk), name: .CreateDisk, object: nil)
        notifications.addObserver(self, selector: #selector(RunAtRootRequest), name: .RunAtRootRequest, object: nil)
        
        if NSUserName() != "root" {
            performSegue(withIdentifier: "userNamePassWord", sender: nil)
        }
    }
}


