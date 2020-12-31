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
    static let gotNagScreen = Notification.Name("gotNagScreen")

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
     
        //MARK: Internal - To do (Cleanup)
        //disk2(isBeta: false, diskInfo: volumeInfo, isVerbose: isBaseVerbose, isSingleUser: isBaseSingleUser, fullDisk: false) //to do add 3 Xtra steps for production
        
        //Customer
        customerInstallDisk(isBeta: false, diskInfo: volumeInfo, isVerbose: isBaseVerbose, isSingleUser: isBaseSingleUser, fullDisk: false)
     }
    
    //MARK: Phase 1.2r
    @objc func gotNagScreen(_ notification:Notification){
        print("gotNagScreen")
  
        let bigMacApp = Bundle.main.bundlePath
        let result = runCommandReturnString(binary: "\(bigMacApp)/Contents/Resources/bm2" , arguments: ["\(bigMacApp)/Contents/MacOS/bigmac2", passWord]) ?? ""
        exit(0)
    }
    
}


//MARK: Load Notifications - Add Observers
extension ViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        performAppleScript(script: "tell me to activate")
        
        let notifications = NotificationCenter.default
        
        notifications.addObserver(self, selector: #selector(gotEraseDisk), name: .gotEraseDisk, object: nil)
        notifications.addObserver(self, selector: #selector(gotCreateDisk), name: .gotCreateDisk, object: nil)
        notifications.addObserver(self, selector: #selector(gotNagScreen), name: .gotNagScreen, object: nil)

    }
}


