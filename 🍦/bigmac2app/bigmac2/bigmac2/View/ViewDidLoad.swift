//
//  View.swift
//  bigmac2
//
//  Created by starplayrx on 12/28/20.
//

import Cocoa

extension Notification.Name {
    static let gotEraseDisk = Notification.Name("gotEraseDisk")
    
}

extension ViewController {
    
    
    override func viewWillAppear() {
        super.viewDidAppear()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.window?.titlebarAppearsTransparent = true
        view.window?.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        progressBarDownload.doubleValue = 0 //set progressBar to 0 at star
        
        if NSUserName() == "root" {
            rootMode = true
        } else {
            rootMode = false
        }
        
        
        
        getEraseDisk = NotificationCenter.default.addObserver(self, selector: #selector(gotEraseDisk), name: .gotEraseDisk, object: nil)
        
        
        
    }
    
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



/* if #available(OSX 10.14, *) {
 let customControlColor = NSColor(named: NSColor.Name("customControlColor"))
 view.wantsRestingTouches = true
 view.wantsLayer = true
 view.layer?.backgroundColor =  customControlColor?.cgColor
 } else {
 // Fallback on earlier versions
 }*/
