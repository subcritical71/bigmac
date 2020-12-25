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
    
    var volumeArray = [myVolumeInfo]()
    
    func refresh() {
        if let volArr = getVolumeInfo(includeHiddenVolumes: false) {
            volumePopup.removeAllItems()
    
            for i in volArr {
                volumePopup.addItem(withTitle: i.volumeName)
            }
            
            volumeArray = volArr
        }
    }
    
    
 
    override func viewDidLoad() {
        refresh()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(self)
    }
    
    @IBAction func refreshDisks(_ sender: Any) {
        refresh()
    }
    
    @IBAction func eraseDisk(_ sender: Any) {
        dismiss(self)

        //Send disk info
        let int = Int(volumePopup.indexOfSelectedItem)
        let selectedDisk = volumeArray[int]
        NotificationCenter.default.post(name: .gotEraseDisk, object: selectedDisk)

    }
    
    
}




    
    
