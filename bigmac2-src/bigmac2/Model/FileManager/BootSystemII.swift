//
//  BootSystemII.swift
//  bigmac2
//
//  Created by starplayrx on 1/4/21.
//

import Foundation

extension ViewController {
    
    //MARK: Update Base System - Preboot and System
    func BootSystemII(system: myVolumeInfo, dataVolumeUUID: String, isVerbose: Bool, isSingleUser: Bool, prebootVolume : String) {
        
        //MARK: Make Preboot bootable and compatible with C-Key at boot time
        //if let _ = Bundle.main.resourceURL {
            
            //Get Preboot Ready
            let prebootPath = "/tmp/\(prebootVolume)"
            
            func unmount() {
                let unmounts = [prebootPath]
                
                for i in unmounts {
                    runCommand(binary: "/usr/sbin/diskutil", arguments: ["unmount", i])
                }
            }
                      
            if !system.root {
                _ = mkDir(arg:prebootPath)
                runCommand(binary: "/usr/sbin/diskutil", arguments: ["mount", "-mountPoint", prebootPath, prebootVolume])
            }
            
            // diskutil mount -mountPoint /tmp/disk4s2 disk4s2
            let bootPlist = "com.apple.Boot.plist"
            let platformPlist = "PlatformSupport.plist"
            //let buildManifestPlist = "BuildManifest.plist"
                        
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
        <string>\(singleUser)\(verbose)-no_compat_check amfi_get_out_of_my_way=1</string>
    </dict>
</plist>
"""
            //let sysVolPre = "System/Volumes/Preboot"
            //let sysLibCor = "System/Library/CoreServices"
            let libPreSyC = "Library/Preferences/SystemConfiguration"
            //let sysLibTmD = "System/Library/Templates/Data"
            //let restoreDk = "restore"
        
        
                //try? fm.removeItem(atPath: "\(system.path)/\(sysLibTmD)/\(libPreSyC)/\(bootPlist)")
                //try? fm.removeItem(atPath: "\(system.path)/\(sysLibCor)/\(platformPlist)") //Causes more trouble
                try? fm.removeItem(atPath: "\(prebootPath)/\(dataVolumeUUID)/\(libPreSyC)/\(bootPlist)")
                //try? fm.removeItem(atPath: "\(prebootPath)/\(dataVolumeUUID)/\(sysLibCor)/\(platformPlist)") //Causes
           
                //txt2file(text: bootPlistTxt, file:  "\(system.path)/\(sysLibTmD)/\(libPreSyC)/\(bootPlist)")
                
                txt2file(text: bootPlistTxt, file: "\(prebootPath)/\(dataVolumeUUID)/\(libPreSyC)/\(bootPlist)")
                
              
                unmount()

            }
            

        }
    //}
    
