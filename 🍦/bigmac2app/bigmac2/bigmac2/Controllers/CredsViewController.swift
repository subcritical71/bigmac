//
//  UserNamePassWord.swift
//  bigmac2
//
//  Created by starplayrx on 12/19/20.
//

import Foundation
import AppKit

class UserNamePassWord: NSViewController {
    
    @IBOutlet weak var passWordLabel: NSSecureTextField!
    @IBOutlet weak var userNameLabel: NSTextField!
    
    
    override func viewWillAppear() {
        super.viewDidAppear()
        if NSUserName() != "root" && !NSUserName().isEmpty {
            userNameLabel.stringValue = NSUserName()
        }
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
    }
    
    @IBAction func okButton(_ sender: Any) {
        saveNames()
        dismiss(self)
    }
    
}


