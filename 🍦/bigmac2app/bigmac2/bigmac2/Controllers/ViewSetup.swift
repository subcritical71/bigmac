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
        
        isBaseSingleUser ? (singleUserCheckbox.state = .on) : (singleUserCheckbox.state = .off)
        isBaseVerbose ? (verboseUserCheckbox.state = .on) :  (verboseUserCheckbox.state = .off)
    }
}

class MainViewController : NSWindowController {
    
    override func windowDidLoad() {
        _ = performAppleScript(script: "tell me to activate")
        shouldCascadeWindows = true

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
        window?.level = .floating
    
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
