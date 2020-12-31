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
        
        view.window?.titlebarAppearsTransparent = true
        view.window?.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        progressBarDownload.doubleValue = 0 //set progressBar to 0 at star
        
        if NSUserName() == "root" {
            rootMode = true
        } else {
            rootMode = false
        }
        
        installerFuelGauge.doubleValue = 0
        view.window?.level = .floating
        
        let defaults = UserDefaults.standard

        isBaseVerbose    = defaults.bool(forKey: "isBaseVerbose")
        isBaseSingleUser = defaults.bool(forKey: "isBaseSingleUser")
        isSysVerbose     = defaults.bool(forKey: "isSysVerbose")
        isSysSingleUser  = defaults.bool(forKey: "isSysSingleUser")
        
        isBaseSingleUser ? (singleUserCheckbox.state = .on) : (singleUserCheckbox.state = .off)
        isBaseVerbose ? (verboseUserCheckbox.state = .on) :  (verboseUserCheckbox.state = .off)
    }
    

    //MARK: View Did Appear()
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.title = "🍔 Big Mac 2.0"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            
            print(NSUserName())
            if NSUserName() != "root" && (passWord.isEmpty || userName.isEmpty) {
                self.performSegue(withIdentifier: "userNamePassWord", sender: self)
                //let result =  performAppleScript(script: "return  \"HELLO TODD BOSS\"") //add permissions check
            }
        }
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
