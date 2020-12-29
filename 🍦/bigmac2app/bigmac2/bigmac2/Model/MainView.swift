//
//  View.swift
//  bigmac2
//
//  Created by starplayrx on 12/28/20.
//

import Cocoa

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.window?.titlebarAppearsTransparent = true
        view.window?.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)

        view.wantsLayer = true
        view.layer?.backgroundColor =  CGColor(red: 15 / 255, green: 15 / 255, blue: 15 / 255, alpha: 1.0)
        
        progressBarDownload.doubleValue = 0 //set progressBar to 0 at star
        if NSUserName() == "root" {
            rootMode = true
        } else {
            rootMode = false
        }

        getEraseDisk = NotificationCenter.default.addObserver(self, selector: #selector(gotEraseDisk), name: .gotEraseDisk, object: nil)
        getCreateDisk = NotificationCenter.default.addObserver(self, selector: #selector(gotCreateDisk), name: .gotCreateDisk, object: nil)
    }
        
    override func viewWillAppear() {
        super.viewDidAppear()
        installerFuelGauge.doubleValue = 0
    }


    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.level = .floating
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
