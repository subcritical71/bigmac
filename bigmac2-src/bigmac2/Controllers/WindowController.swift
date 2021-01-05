//
//  MainWIndowViewController.swift
//  bigmac2
//
//  Created by starplayrx on 1/4/21.
//

import Cocoa


class WindowController : NSWindowController {
    
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
