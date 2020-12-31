//
//  View.swift
//  bigmac2
//
//  Created by starplayrx on 12/28/20.
//

import Cocoa

//MARK: Notification Extensions
extension Notification.Name {
    static let gotEraseDisk = Notification.Name("gotEraseDisk")
    static let gotCreateDisk = Notification.Name("gotDownloadBigMacDisk")
}


//MARK: Notfications Actions
extension ViewController {
    
     //MARK: Phase 1.1
     @objc func gotEraseDisk(_ notification:Notification){
        
         volumeInfo = notification.object as! myVolumeInfo //Store in a global
        print("HELLO")
        //Got permission to erase a disk, proceed with download of BigMacII disk then Create disk workflow
        downloadBigMac2(dmg:"https://www.starplayrx.com/bigmac2/bigmac2.dmg")
        
        DispatchQueue.main.async { [self] in
            spinnerAnimation(start: true, hide: false)
        }
     }

     //MARK: Phase 1.2
     @objc func gotCreateDisk(_ notification:Notification){
         print("gotCreateDisk")

        DispatchQueue.main.async { [self] in
            isBaseSingleUser = singleUserCheckbox.state == .on
            isBaseVerbose = verboseUserCheckbox.state == .on
            spinnerAnimation(start: true, hide: false)
        }
     
        //Internal
        //disk2(isBeta: false, diskInfo: volumeInfo, isVerbose: isBaseVerbose, isSingleUser: isBaseSingleUser, fullDisk: false) //to do add 3 Xtra steps for production
        
        //Customer
        customerInstallDisk(isBeta: false, diskInfo: volumeInfo, isVerbose: isBaseVerbose, isSingleUser: isBaseSingleUser, fullDisk: false)
     }
    
}


//MARK: Load Notifications - Add Observers
extension ViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let notifications = NotificationCenter.default
        
        notifications.addObserver(self, selector: #selector(gotEraseDisk), name: .gotEraseDisk, object: nil)
        notifications.addObserver(self, selector: #selector(gotCreateDisk), name: .gotCreateDisk, object: nil)
    }
}

