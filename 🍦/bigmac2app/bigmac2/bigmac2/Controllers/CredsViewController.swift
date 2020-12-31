//
//  UserNamePassWord.swift
//  bigmac2
//
//  Created by starplayrx on 12/19/20.
//

import Foundation
import AppKit

class CredsViewController: NSViewController {
    
    @IBOutlet weak var passWordLabel: NSSecureTextField!
    @IBOutlet weak var userNameLabel: NSTextField!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    override func viewWillAppear() {
        super.viewDidAppear()
        progressBar.isHidden = true
        progressBar.startAnimation(self)
        if NSUserName() != "root" && !NSUserName().isEmpty {
            userNameLabel.stringValue = NSUserName()
        }
    }
    
    override func viewWillDisappear() {
        progressBar.isHidden = true
        progressBar.stopAnimation(self)
    }
       
    func saveNames() {
        if !userNameLabel.stringValue.isEmpty {
            userName = userNameLabel.stringValue
        }
        
        if !passWordLabel.stringValue.isEmpty {
           passWord = passWordLabel.stringValue
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        saveNames()
        dismiss(self)
        exit(0)
    }
    
    @IBAction func okButton(_ sender: Any) {
        saveNames()
        progressBar.isHidden = false

       DispatchQueue.main.async { [self] in
                let script = "do shell script \"sudo echo /\" user name \"\(userName)\" password \"\(passWord)\" with administrator privileges" 
                let result = performAppleScript(script: script)
                if let a = result.text, a.contains("incorrect") {
                passWordLabel.resignFirstResponder()
                passWordLabel.shake(duration: 1)
                progressBar.isHidden = true
                passWordLabel.stringValue = ""
            } else {
                progressBar.isHidden = true
                dismiss(self)
                NotificationCenter.default.post(name: .gotNagScreen, object: nil)

            }
        }
    
    }
}

extension NSView {
    func shake(duration: CFTimeInterval) {

        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]

        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation]
        shakeGroup.duration = duration
        self.layer?.add(shakeGroup, forKey: "shakeIt")
        
    }
}



