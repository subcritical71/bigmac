//
//  AppDelegate.swift
//  bigmac2
//
//  Created by starplayrx on 12/18/20.
//

import AppKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    

      
    
    
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag == false {

            for window in sender.windows {
                print(window)
                if (window.delegate?.isKind(of: ViewController.self)) == true {
                    window.orderFront(self)
                } else {
                    window.makeKeyAndOrderFront(self)

                }
            }
        }

        return true
    }
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

