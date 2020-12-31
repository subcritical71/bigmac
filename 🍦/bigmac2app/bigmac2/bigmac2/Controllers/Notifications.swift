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
    
    //MARK: Phase 1.2
    @objc func gotNagScreen(_ notification:Notification){
        print("gotNagScreen")
        
        let bigMacApp = Bundle.main.bundlePath

        
        let script =
"""
 
   display dialog "Please Quit and Relaunch to run as administrator." with icon 1 buttons {"Quit and Relaunch"} with title "🍔 Big Mac 2.0" default button 1

   tell application "bigmac2" to quit
    
    do shell script "\(bigMacApp)/Contents/MacOS/bigmac2 > /dev/null 2>&1 &" user name "\(userName)" password "\(passWord)" with administrator privileges
    

"""
        
        performAppleScript(script: script)
    }
    
}


//MARK: Load Notifications - Add Observers
extension ViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notifications = NotificationCenter.default
        
        notifications.addObserver(self, selector: #selector(gotEraseDisk), name: .gotEraseDisk, object: nil)
        notifications.addObserver(self, selector: #selector(gotCreateDisk), name: .gotCreateDisk, object: nil)
        notifications.addObserver(self, selector: #selector(gotNagScreen), name: .gotNagScreen, object: nil)

    }
}

