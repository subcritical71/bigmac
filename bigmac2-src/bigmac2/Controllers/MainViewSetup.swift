//
//  ViewSetup.swift
//  bigmac2
//
//  Created by starplayrx on 12/30/20.
//

import Cocoa




//MARK: Main View Setup
extension ViewController {
    
    //MARK: View Will Appear
    override func viewWillAppear() {
        super.viewDidAppear()
    
        
 
        
        progressBarDownload.doubleValue = 0 //set progressBar to 0 at star
        
        if NSUserName() == "root" {
            rootMode = true
        } else {
            rootMode = false
        }
        
        installerFuelGauge.doubleValue = 0
   
        let defaults = UserDefaults.standard

        isBaseVerbose    = defaults.bool(forKey: "isBaseVerbose")
        isBaseSingleUser = defaults.bool(forKey: "isBaseSingleUser")
        isSysVerbose     = defaults.bool(forKey: "isSysVerbose")
        isSysSingleUser  = defaults.bool(forKey: "isSysSingleUser")
        
        enableUSB       = defaults.bool(forKey: "enableUSB")
        disableBT2      = defaults.bool(forKey: "disableBT2")
        amdMouSSE       = defaults.bool(forKey: "amdMouSSE")
        teleTrap        = defaults.bool(forKey: "teleTrap")
        VerboseBoot     = defaults.bool(forKey: "VerboseBoot")
        superDrive      = defaults.bool(forKey: "superDrive")
        appStoreMacOS   = defaults.bool(forKey: "appStoreMacOS")
        appleHDA        = defaults.bool(forKey: "appleHDA")
        hdmiAudio       = defaults.bool(forKey: "hdmiAudio")
        singleUser      = defaults.bool(forKey: "singleUser")
        legacyWiFi      = defaults.bool(forKey: "legacyWiFi")
        installKCs      = defaults.bool(forKey: "installKCs")
        blessSystem     = defaults.bool(forKey: "blessSystem")
        deleteSnaphots  = defaults.bool(forKey: "deleteSnaphots")
        
        isBaseSingleUser ? (singleUserCheckbox.state = .on) : (singleUserCheckbox.state = .off)
        isBaseVerbose    ? (verboseUserCheckbox.state = .on) : (verboseUserCheckbox.state = .off)
        
        enableUSB       ? (enableUSB_btn.state = .on)       : (enableUSB_btn.state = .off)
        disableBT2      ? (disableBT2_btn.state = .on)      : (disableBT2_btn.state = .off)
        amdMouSSE       ? (amdMouSSE_btn.state = .on)       : (amdMouSSE_btn.state = .off)
        teleTrap        ? (teleTrap_btn.state = .on)        : (teleTrap_btn.state = .off)
        VerboseBoot     ? (VerboseBoot_btn.state = .on)     : (VerboseBoot_btn.state = .off)
        superDrive      ? (superDrive_btn.state = .on)      : (superDrive_btn.state = .off)
        appStoreMacOS   ? (appStoreMacOS_btn.state = .on)   : (appStoreMacOS_btn.state = .off)
        appleHDA        ? (appleHDA_btn.state = .on)        : (appleHDA_btn.state = .off)
        hdmiAudio       ? (hdmiAudio_btn.state = .on)       : (hdmiAudio_btn.state = .off)
        singleUser      ? (singleUser_btn.state = .on)      : (singleUser_btn.state = .off)
        legacyWiFi      ? (legacyWiFi_btn.state = .on)      : (legacyWiFi_btn.state = .off)
        installKCs      ? (updateBootSysKCs.state = .on)    : (updateBootSysKCs.state = .off)
        blessSystem     ? (BlessVolume.state = .on)         : (BlessVolume.state = .off)
        deleteSnaphots  ? (deleteAPFSSnapshotsButton.state = .on) : (deleteAPFSSnapshotsButton.state = .off)

        print(blessSystem)
 
    }
}

class MainViewController : NSWindowController {
    
    override func windowDidLoad() {
        _ = performAppleScript(script: "tell me to activate")
        shouldCascadeWindows = false

        if NSUserName() == "root" {
            window?.setFrameAutosaveName("bigMacMainView")
        } else {
            window?.alphaValue = 0.0
            window?.setFrameAutosaveName("") // don't save window position if it's not the root user. Otherwise things get weird
        }
        
        super.windowDidLoad()
        window?.titlebarAppearsTransparent = true
        window?.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        window?.title = "🍔 Big Mac 2.0"
        window?.level = .normal

    }
    
}



//Backburner.. easier not ot use this

/* if #available(OSX 10.14, *) {
 let customControlColor = NSColor(named: NSColor.Name("customControlColor"))
 view.wantsRestingTouches = true
 view.wantsLayer = true
 view.layer?.backgroundColor =  customControlColor?.cgColor
 } else {
 // Fallback on earlier versions
 }*/
