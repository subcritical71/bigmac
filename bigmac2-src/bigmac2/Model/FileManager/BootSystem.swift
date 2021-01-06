//
//  BootSystem.swift
//  bigmac2
//
//  Created by starplayrx on 1/4/21.
//

import Foundation

extension ViewController {
    
    //MARK: Update Base System - Preboot and System
    func BootSystem(system: myVolumeInfo, dataVolumeUUID: String, isVerbose: Bool, isSingleUser: Bool, prebootVolume : String, isBaseSystem: Bool = false) {
        
        //MARK: Make Preboot bootable and compatible with C-Key at boot time
        //if let _ = Bundle.main.resourceURL {
            
            //Get Preboot Ready
            let prebootPath = "/tmp/\(prebootVolume)"
            
            func forceUnmounts() {
                let unmounts = [prebootVolume, "Recovery", "Update"]
                
                for i in unmounts {
                    _ = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["unmount", "force", i])

                }
            }
          
            forceUnmounts()
            
            if !system.root {
                _ = mkDir(arg:prebootPath)
                _ = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["mount", "-mountPoint", prebootPath, prebootVolume])
            }
            
            // diskutil mount -mountPoint /tmp/disk4s2 disk4s2
            let bootPlist = "com.apple.Boot.plist"
            let platformPlist = "PlatformSupport.plist"
            let buildManifestPlist = "BuildManifest.plist"
                        
            var verbose = "-v "
            var singleUser = "-s "
            
            if !isVerbose {
                verbose = ""
            }
            
            if !isSingleUser {
                singleUser = ""
            }
            
            //Write our pList file
            let bootPlistTxt =
                """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Kernel Flags</key>
        <string>\(singleUser)\(verbose)-no_compat_check -amfi_get_out_of_my_way=1</string>
    </dict>
</plist>
"""
            //MARK: Delete Items
            if system.root {
                
                if !isBaseSystem {
                    try? fm.removeItem(atPath: "\(system.path)Library/Preferences/SystemConfiguration/\(bootPlist)")
                    try? fm.removeItem(atPath: "\(system.path)System/Volumes/Preboot/\(dataVolumeUUID)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                    try? fm.removeItem(atPath: "\(system.path)System/Volumes/Preboot/\(dataVolumeUUID)/System/Library/CoreServices/\(platformPlist)") //Causes more trouble
                    try? fm.removeItem(atPath: "\(system.path)System/Volumes/Preboot/\(dataVolumeUUID)/restore/\(buildManifestPlist)") //Causes more trouble
                }
                
                try? fm.removeItem(atPath: "\(system.path)System/Library/Templates/Data/Library/Preferences/SystemConfiguration/\(bootPlist)")
                try? fm.removeItem(atPath: "\(system.path)System/Library/CoreServices/\(platformPlist)") //Causes more trouble

            } else {
                if !isBaseSystem {
                    try? fm.removeItem(atPath: "\(system.path)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                }
                
                try? fm.removeItem(atPath: "\(system.path)/System/Library/Templates/Data/Library/Preferences/SystemConfiguration/\(bootPlist)")
                try? fm.removeItem(atPath: "\(system.path)/System/Library/CoreServices/\(platformPlist)") //Causes more trouble
                try? fm.removeItem(atPath: "\(prebootPath)/\(dataVolumeUUID)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                try? fm.removeItem(atPath: "\(prebootPath)/\(dataVolumeUUID)/System/Library/CoreServices/\(platformPlist)") //Causes more trouble
                try? fm.removeItem(atPath: "\(prebootPath)/\(dataVolumeUUID)/restore/\(buildManifestPlist)") //Causes more trouble
            }
            
            //MARK: write boot plist items back
            if system.root {
                
                if !isBaseSystem {
                    txt2file(text: bootPlistTxt, file: "\(system.path)Library/Preferences/SystemConfiguration/\(bootPlist)")
                }
                
                txt2file(text: bootPlistTxt, file:  "\(system.path)System/Library/Templates/Data/Library/Preferences/SystemConfiguration/\(bootPlist)")
                txt2file(text: bootPlistTxt, file:  "\(system.path)System/Volumes/Preboot/\(dataVolumeUUID)/Library/Preferences/SystemConfiguration/\(bootPlist)")
            } else {
                
                if !isBaseSystem {
                    txt2file(text: bootPlistTxt, file:  "\(system.path)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                }
                
                txt2file(text: bootPlistTxt, file:  "\(system.path)/System/Library/Templates/Data/Library/Preferences/SystemConfiguration/\(bootPlist)")
                txt2file(text: bootPlistTxt, file:  "\(prebootPath)/\(dataVolumeUUID)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                
            }
            
            forceUnmounts()

        }
    //}
    
}
