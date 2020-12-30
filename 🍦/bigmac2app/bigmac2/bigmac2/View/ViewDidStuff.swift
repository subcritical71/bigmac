//
//  View.swift
//  bigmac2
//
//  Created by starplayrx on 12/28/20.
//

import Cocoa

extension ViewController {
   
        
    override func viewWillAppear() {
        super.viewDidAppear()
        installerFuelGauge.doubleValue = 0
        view.window?.level = .floating

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
        getCreateDisk = NotificationCenter.default.addObserver(self, selector: #selector(gotCreateDisk), name: .gotCreateDisk, object: nil)
        getAppChanged = NotificationCenter.default.addObserver(self, selector: #selector(gotAppChanged), name: .gotAppChanged, object: nil)
        
       /* if #available(OSX 10.14, *) {
            let customControlColor = NSColor(named: NSColor.Name("customControlColor"))
            view.wantsRestingTouches = true
            view.wantsLayer = true
            view.layer?.backgroundColor =  customControlColor?.cgColor
        } else {
            // Fallback on earlier versions
        }*/
       
        //nvram -p | grep boot-args
        var bootargs = runCommandReturnString(binary: "/usr/sbin/nvram", arguments: ["-p"])
        
        var nvramArray = bootargs?.components(separatedBy: "\n")
        
        if let nvramArray = nvramArray {
            for i in nvramArray {
                if i.contains("boot-args") {
                    bootargs = i
                }
            }
        }
      
        bootargs = bootargs?.replacingOccurrences(of: "boot-args\t", with: "")
        //bootargs = bootargs?.replacingOccurrences(of: "    ", with: "")
        
        if let b = bootargs, !b.isEmpty {
            bootArgsField.stringValue = b
        } else {
            bootArgsField.stringValue = ""
        }
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


