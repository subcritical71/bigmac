//
//  EraseDisk.swift
//  bigmac2
//
//  Created by starplayrx on 12/24/20.
//

import Foundation
import AppKit


class EraseDiskViewController : NSViewController {
    
    @IBOutlet weak var volumePopup: NSPopUpButton!
    @IBOutlet weak var cancel: NSButton!
    @IBOutlet weak var okButton: NSButton!
    @IBOutlet weak var eraseDiskEntry: NSTextField!
    
    var volumeArray = [myVolumeInfo]()
    
    func refresh() {
        if let volArr = getVolumeInfo(includeHiddenVolumes: false) {
            volumePopup.removeAllItems()
            
            if volArr.count == 0 || volArr.isEmpty {
                volumePopup.addItem(withTitle: "No APFS volumes or partitions")
                okButton.isEnabled = false
            } else {
                for i in volArr {
                    volumePopup.addItem(withTitle: i.volumeName)
                    okButton.isEnabled = true
                }
                
                volumeArray = volArr
            }
        }
    }
    
    override func viewDidLoad() {
        refresh()
        eraseDiskEntry.focusRingType = .none
        volumePopup.focusRingType = .none
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(self)
    }
    
    @IBAction func refreshDisks(_ sender: Any) {
        refresh()
    }
    
    @IBAction func eraseDisk(_ sender: Any) {
        
        if eraseDiskEntry.stringValue == volumePopup.title {
            dismiss(self)
            //Send disk info
            let int = Int(volumePopup.indexOfSelectedItem)
            let selectedDisk = volumeArray[int]
            
            if globalInstalldmg {
                NotificationCenter.default.post(name: .EraseInstallDisk, object: selectedDisk)
            } else {
                NotificationCenter.default.post(name: .EraseDisk, object: selectedDisk)
            }
            
        } else {
            eraseDiskEntry.shake(duration: 1)
        }
    }
}


