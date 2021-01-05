//
//  InstallerDiskController.swift
//  bigmac2
//
//  Created by starplayrx on 1/4/21.
//

import Cocoa

class InstallViewController: NSViewController {

  
    override func viewWillAppear() {
        super.viewDidAppear()
       
    }
    
    override func viewWillDisappear() {
    }
    
    @IBAction func donateButton_Action(_ sender: Any) {
        if let url = URL(string: "https://www.paypal.com/donate?hosted_button_id=M3U48FLF87SXQ") {
            NSWorkspace.shared.open(url)
        }
        
        dismiss(self)

    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(self)
    }
    
    override func viewDidLoad() {
        view.window?.titlebarAppearsTransparent = true
        view.window?.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        view.window?.title = "🍔 Big Mac 2.0"
        view.window?.level = .floating
        view.window?.styleMask = .borderless
    }
    
    @IBAction func okButton(_ sender: Any) {
        
        var bless = globalVolumeInfo.path + "/usr/sbin/bless"
        var path = globalVolumeInfo.path + "/"
        
        if globalVolumeInfo.root {
            bless = globalVolumeInfo.path + "usr/sbin/bless"
            path = globalVolumeInfo.path
        }
        
        _ = runCommandReturnString(binary: bless, arguments: ["--mount", "\(path)", "--folder", "\(path)System/Library/CoreServices", "--bootefi", "--label", globalVolumeInfo.displayName, "--setBoot", "--nextonly"])
        
        _ = runCommandReturnString(binary: "/sbin/reboot", arguments: [])
        
        dismiss(self)

    }
    

}
