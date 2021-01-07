//
//  PreInstallActions.swift
//  bigmac2
//
//  Created by starplayrx on 12/31/20.
//
import Cocoa

extension ViewController {
    @IBAction func LaunchInstallerAction(_ sender: Any) {
        
        let bootArgs = bootArgsField.stringValue
        let libVal = DisableLibraryValidation.state == .on
        let SIP = DisableSIP.state == .on
        let AR = DisableAuthRoot.state == .on
        
        func macOS(installer: String) {
            if !ranHax3 {
                ranHax3 = true
                let hax = runCommandReturnString(binary: "/bin/launchctl" , arguments: ["setenv", "DYLD_INSERT_LIBRARIES", "/\(tmp)/\(bigdata)/\(haxDylib)"]) ?? ""
                print(hax)
            }
            
            let bigMacApp = Bundle.main.bundlePath
            _ = runCommandReturnString(binary: "\(bigMacApp)/Contents/Resources/lax" , arguments: [installer]) ?? ""
             
            DispatchQueue.global(qos: .background).async {
                for i in 1...6 {
                    sleep(1)
                    DispatchQueue.main.async { [self] in
                        preInstallSpinner.doubleValue = Double(i)
                        if i > 5 {
                            exit(0)
                        }
                    }
                }
            }
        }
        
        func preInstallRunner(libVal: Bool, SIP: Bool, AR: Bool) {
            
            if !bootArgs.isEmpty {
                _ = runCommandReturnString(binary: "/usr/sbin/nvram" , arguments: ["boot-args=\(bootArgs)"]) ?? ""
            }
            
            if libVal {
                _ = runCommandReturnString(binary: "/usr/bin/defaults" , arguments: ["write", "/Library/Preferences/com.apple.security.libraryvalidation.plist", "DisableLibraryValidation", "-bool", "true"]) ?? ""
            }
            
            //MARK: Disable SIP
            if SIP {
                _ = runCommandReturnString(binary: "/usr/bin/csrutil" , arguments: ["disable"]) ?? ""
            }
            
            //MARK: Disable AR
            if AR {
                _ = runCommandReturnString(binary: "/usr/bin/csrutil" , arguments: ["authenticated-root", "disable"]) ?? ""
            }
            
            
            let script = """
            
            display dialog "Only clean installs from Mac OS Extended Journaled (JHFS+) volumes are supported from a full OS. To install or upgrade directly to APFS disks, boot from the bigmac2 Installation Disk. Hint try rebooting and hold down the C key. Note: installing to JHFS+ will be converted to APFS during the install." buttons {"OK"} default button 1 with icon 1
            
            """
            let installAsstBaseOS = "/Install macOS Big Sur.app/Contents/MacOS/InstallAssistant"
            let installAsstFullOS = "/Applications/Install macOS Big Sur.app/Contents/MacOS/InstallAssistant"
           // let installAsstBootOS = "/Volumes/bigmac2/Install macOS Big Sur.app/Contents/MacOS/InstallAssistant"
            
            
            let fm = FileManager.default
            if fm.fileExists(atPath: installAsstBaseOS) {
                
                macOS(installer: installAsstBaseOS)
               
            } else if fm.fileExists(atPath: installAsstFullOS) {
                
                _ = performAppleScript(script: script)
                macOS(installer: installAsstFullOS)
            }
        }
        preInstallRunner(libVal: libVal, SIP: SIP, AR: AR)
    }
}


/*
 
 #!/bin/sh

 if [ ! -d "/usr/local/lib" ]; then
   echo "Creating directory \"/usr/local/lib\"..."
   sudo mkdir "/usr/local/lib"
 fi

 echo "Downloading \"SUVMMFaker.dylib\"..."
 sudo curl -o "/usr/local/lib/SUVMMFaker.dylib" "http://dosdude1.com/sierra/swupatch/SUVMMFaker.dylib"
 sudo chmod 755 "/usr/local/lib/SUVMMFaker.dylib"

 echo "Backing up com.apple.softwareupdated.plist..."
 cp "/System/Library/LaunchDaemons/com.apple.softwareupdated.plist" ~

 echo "Downloading \"com.apple.softwareupdated.plist\"..."
 sudo curl -o "/System/Library/LaunchDaemons/com.apple.softwareupdated.plist" "http://dosdude1.com/sierra/swupatch/com.apple.softwareupdated.plist"

 echo "Restarting softwareupdated..."
 sudo launchctl unload /System/Library/LaunchDaemons/com.apple.softwareupdated.plist && sudo launchctl load /System/Library/LaunchDaemons/com.apple.softwareupdated.plist
 
 */
