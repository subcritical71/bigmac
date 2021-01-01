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
            
            let installAsst = "/Install macOS Big Sur.app/Contents/MacOS/InstallAssistant"
            
            let fm = FileManager.default
            if fm.fileExists(atPath: installAsst) {
                if libVal {
                    _ = runCommandReturnString(binary: "/usr/bin/defaults" , arguments: ["write", "/Library/Preferences/com.apple.security.libraryvalidation.plist", "DisableLibraryValidation", "-bool", "true"]) ?? ""
                }
                
                _ = runCommandReturnString(binary: "/bin/launchctl" , arguments: ["setenv", "DYLD_INSERT_LIBRARIES", haxDylib]) ?? ""
                let bigMacApp = Bundle.main.bundlePath
                
                _ = runCommandReturnString(binary: "\(bigMacApp)/Contents/Resources/lax" , arguments: ["installAsst"]) ?? ""
                
                
            } else {
                //To do: make this a sheet
                let string = """
                    Display Dialog "Please boot the bigmac2 installation disk, then run this task there. Type try using the C key during boot." buttons {"OK"} default button 1 with title "Boot me from bigmac2" with icon 1
                """
                performAppleScript(script: string)
            }
            
            
            
        }
        
        preInstallRunner(libVal: libVal, SIP: SIP, AR: AR)
    }
}
