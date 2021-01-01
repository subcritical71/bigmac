//
//  PreInstallActions.swift
//  bigmac2
//
//  Created by starplayrx on 12/31/20.
//

import Foundation


extension ViewController {
    @IBAction func LaunchInstallerAction(_ sender: Any) {
        
        let bootArgs = bootArgsField.stringValue
        let libVal = DisableLibraryValidation.state == .on
        let SIP = DisableSIP.state == .on
        let AR = DisableAuthRoot.state == .on
        
        func preInstallRunner(libVal: Bool, SIP: Bool, AR: Bool) {
            
            if !bootArgs.isEmpty {
                _ = runCommandReturnString(binary: "/usr/sbin/nvram" , arguments: ["boot-args=\(bootArgs)"]) ?? ""
            }
            
            if libVal {
                _ = runCommandReturnString(binary: "/usr/bin/defaults" , arguments: ["write", "/Library/Preferences/com.apple.security.libraryvalidation.plist", "DisableLibraryValidation", "-bool", "true"]) ?? ""
            }
            
            let installAsstBaseOS = "/Install macOS Big Sur.app/Contents/MacOS/InstallAssistant"
            let installAsstFullOS = "/Volumes/bigmac2/Install macOS Big Sur.app/Contents/MacOS/InstallAssistant"

            let fm = FileManager.default
            if fm.fileExists(atPath: installAsstBaseOS) {
               
                if !ranHax3 {
                    ranHax3 = true
                    _ = runCommandReturnString(binary: "/bin/launchctl" , arguments: ["setenv", "DYLD_INSERT_LIBRARIES", haxDylib]) ?? ""
                }
                
                let bigMacApp = Bundle.main.bundlePath
                _ = runCommandReturnString(binary: "\(bigMacApp)/Contents/Resources/lax" , arguments: [installAsstFullOS]) ?? ""
                                
            } else if fm.fileExists(atPath: installAsstFullOS) {
                
                let script = """
                
                display dialog "Only clean installs from Mac OS Extended (Journaled) Installs are supported from a full OS. To install or upgrade directly to APFS disks, boot from the bigmac2 Installation Disk." buttons {"OK"} default button 1 with icon 1
                
                """
                
                _ = performAppleScript(script: script) //To Do make this a native sheet
                
                if !ranHax3 {
                    ranHax3 = true
                    _ = runCommandReturnString(binary: "/bin/launchctl" , arguments: ["setenv", "DYLD_INSERT_LIBRARIES", haxDylib]) ?? ""
                }
               
                let bigMacApp = Bundle.main.bundlePath
                _ = runCommandReturnString(binary: "\(bigMacApp)/Contents/Resources/lax" , arguments: [installAsstFullOS]) ?? ""
            }
        }
        
        preInstallRunner(libVal: libVal, SIP: SIP, AR: AR)
    }
}
