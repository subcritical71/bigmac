//
//  Utilities.swift
//  bigmac2
//
//  Created by starplayrx on 1/1/21.
//

import Cocoa


extension ViewController {
    
    // MARK: Get System Info
    func getSystemInfo(drive:String) -> systemInfoCodable?   {
        
        let path = "/Volumes/\(drive)/System/Library/CoreServices/SystemVersion.plist"
        if checkIfFileExists(path: path) {
            let systemPath = path
            //let systemURL = NSURL(string: systemPath)
            let systemURL = URL(fileURLWithPath: systemPath)
            var systemInfo : systemInfoCodable?
            do {
                
            
                let data = try Data(contentsOf: systemURL )
                let decoder = PropertyListDecoder()
                systemInfo = try decoder.decode(systemInfoCodable.self, from: data)
                
                return systemInfo
            } catch {
                print(error)
            }
        }
    
        return nil
    }
    
    func disableSetResXButtonsCheck() {
        if !fm.fileExists(atPath: setResX) {
            LowRes_720.isEnabled = false
            HiRes_720.isEnabled = false
            LowRes_1080.isEnabled = false
            HiRes_1080.isEnabled = false
        }
    }
    
    //MARK: Move to Utilities
    func checkIfFileExists(path: String) -> Bool {
        if fm.fileExists(atPath: path) {
            return true
        } else {
            return false
        }
    }
    
    func checkForBaseOS() -> Bool {
        if fm.fileExists(atPath: baseOS) {
            return true
        } else {
            return false
        }
    }
    
    

    
    func refreshPatchDisks() {
        if let getDisks = getVolumeInfo(includeHiddenVolumes: false, includeRootVol: true) {
            
            availablePatchDisks.removeAllItems()
            
            for i in getDisks {
                var drive = ""
                if i.root {
                    drive = i.displayName
                } else {
                    drive = i.volumeName
                }
                
                //MARK: bigmac2 is omitted, we don't want users trying to patch bigmac2
                if let systemInfo = getSystemInfo(drive: drive), i.displayName != bigmac2Str {
                    let majorMinorVersion = systemInfo.productUserVisibleVersion.components(separatedBy: ".")
                   // print ( majorMinorVersion, i.displayName, i.root )
                    
                    if majorMinorVersion.first == "11" {
                        availablePatchDisks.addItem(withTitle: drive)
                    }
                }
            }
        }
    }
    
    //Gather checboxes
    func patchBool() {
        enableUSB       = enableUSB_btn.state == .on
        enableUSBtl     = enableUSB_btn.title
        
        disableBT2      = disableBT2_btn.state == .on
        disableBT2tl    = disableBT2_btn.title
        
        amdMouSSE       = amdMouSSE_btn.state == .on
        amdMouSSEtl     = amdMouSSE_btn.title

        teleTrap        = teleTrap_btn.state == .on
        teleTraptl      = teleTrap_btn.title
        
        VerboseBoot     = VerboseBoot_btn.state == .on
        VerboseBoottl   = VerboseBoot_btn.title

        superDrive      = superDrive_btn.state == .on
        superDrivetl    = superDrive_btn.title
        
        appleHDA        = appleHDA_btn.state == .on
        appleHDAtl      = appleHDA_btn.title
        
        hdmiAudio       = hdmiAudio_btn.state == .on
        hdmiAudiotl     = hdmiAudio_btn.title
        
        appStoreMacOS   = appStoreMacOS_btn.state == .on
        appStoreMacOStl = appStoreMacOS_btn.title
        
        singleUser      = singleUser_btn.state == .on
        singleUsertl    = singleUser_btn.title
        
        legacyWiFi      = legacyWiFi_btn.state == .on
        legacyWiFitl    = legacyWiFi_btn.title
        
        installKCs      = updateBootSysKCs.state == .on
        installKCstl    = updateBootSysKCs.title
        
        blessSystem     = BlessVolume.state == .on
        blessSystemtl   = BlessVolume.title
        
        deleteSnaphots   = deleteAPFSSnapshotsButton.state == .on
        deleteSnaphotstl = deleteAPFSSnapshotsButton.title
        
        driv            = availablePatchDisks.title
    }
    
    
    func installKext(dest: String, kext: String, fold: String, prfx: String = "", ttle: String = "") -> Bool {
        var strg = ""
        let fail = "Do not pass"
        var pass = false
        let copy = "Copying"
        let inst = "Installing"
        let dots = "..."
        if let source = Bundle.main.resourceURL?.path {
            let destiny = "\(dest)/\(fold)/\(kext)"
            let mdir = "\(dest)/\(fold)/"
            
            if ttle.isEmpty {
                indicatorBump(taskMsg: "\(inst) \(kext)\(dots)", detailMsg: "\(destiny)")
            } else {
                indicatorBump(taskMsg: "\(inst) \(ttle)\(dots)", detailMsg: "\(destiny)")
            }

            //MARK: To do add check if directory exists
            
            if kext.contains("lib") {
                _ = runCommandReturnString(binary: "/bin/mkdir", arguments: [mdir])
            }
            
            //MARK: Sour is used as a special prefix for the source file incase the name is different.
            strg = runCommandReturnString(binary: "/usr/bin/ditto", arguments: ["-v", "\(source)/\(prfx)\(kext)", destiny]) ?? fail
            _ = runCommandReturnString(binary: "/usr/sbin/chown", arguments: ["-R", "0:0", destiny])
            _ = runCommandReturnString(binary: "/bin/chmod", arguments: ["-R", "755", destiny])
            _ = runCommandReturnString(binary: "/usr/bin/touch", arguments: [destiny])
        }
        
        strg = strg.replacingOccurrences(of: "\n", with: "")
        strg = strg.replacingOccurrences(of: "\r", with: "")
        strg = strg.replacingOccurrences(of: " ", with: "")
        
        if strg.hasPrefix(copy) && strg.hasSuffix(kext)  {
            pass = !pass
        }
        

        return pass
    }
    
    
    //MARK: This a better preboot routine
    func getDisk(substr: String, usingDiskorSlice: String, isSlice: Bool) -> String? {
        
        let pb = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["list", usingDiskorSlice]) ?? ""
        let pbArray = pb.components(separatedBy: "\n")
        
        for i in pbArray {
            if i.contains(substr) {
                if isSlice {
                    let prebootVolume = String(i.suffix(usingDiskorSlice.count))
                    return prebootVolume
                } else {
                    let prebootVolume = String(i.suffix(usingDiskorSlice.count + 2))
                    return prebootVolume
                }
            }
        }
        
        return nil
        
    }
    
    
    //MARK: Update Base System - Preboot and System
    func BootSystem(system: myVolumeInfo, dataVolumeUUID: String, isVerbose: Bool, isSingleUser: Bool, prebootVolume : String, isBaseSystem: Bool = false) {
        
        //MARK: Make Preboot bootable and compatible with C-Key at boot time
        if let _ = Bundle.main.resourceURL {
            
            //Get Preboot Ready
            let prebootPath = "/tmp/\(prebootVolume)"
            
            func forceUnmounts() {
                let unmounts = ["Preboot", prebootVolume, "Recovery", "Update"]
                
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
    }
    
    
        
   
    /* Update System Caches on macOS 11.1 */
    func updateMac11onMac11SystemCache(destVolume: String) {
        
        //MARK: Constants
        let appleSysLib     = "Library/Apple/System/Library"
        let appleSysLibExt  = "Library/Apple/System/Library/Extensions"
        let appleSysLibPre  = "Library/Apple/System/Library/PrelinkedKernels"
        let prelinkedkernel = "System/Library/PrelinkedKernels/prelinkedkernel"
        let sysLibExt       = "System/Library/Extensions"
        let sysLibDriverExt = "System/Library/DriverExtensions"
        let libExt          = "Library/Extensions"
        let libDriveExt     = "Library/DriverExtensions"
        let kernel          = "System/Library/Kernels/kernel"
        
        //MARK: Commands
        let touch =         "\(destVolume)usr/bin/touch"
        let kmutil =        "\(destVolume)usr/bin/kmutil"
        let kcditto =       "\(destVolume)usr/sbin/kcditto"
                
        let appleSysLibExists               = checkIfFileExists(path: "\(destVolume)\(appleSysLib)")
        let appleSysLibPreKernelsExists     = checkIfFileExists(path: "\(destVolume)\(appleSysLibPre)")

        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(appleSysLib)"])
        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(appleSysLibExt)"])
        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(sysLibExt)"])
        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(sysLibDriverExt)"])
        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(libExt)"])
        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(libDriveExt)"])
        
        
       //MARK: Updating All Kernel Extensions
        let kmArrA = ["install", "--update-all", "--check-rebuild", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
        runIndeterminateProcess(binary: kmutil, arguments: kmArrA, title: "Updating All Kernel Extensions...")
        
        indicatorBump(updateProgBar: true)

        //MARK: Rechecking Extensions
        let kmArrRE = ["install", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
        runIndeterminateProcess(binary: kmutil, arguments: kmArrRE, title: "Rechecking Extensions...")
        
        indicatorBump(updateProgBar: true)

        //MARK: Updating Library Extensions
        let kmArrB = ["install", "--check-rebuild", "--repository", "/\(libExt)", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
        runIndeterminateProcess(binary: kmutil, arguments: kmArrB, title: "Updating Library Extensions...")
    
        indicatorBump(updateProgBar: true)

        if appleSysLibExists {
            
            if !appleSysLibPreKernelsExists {
                _ = mkDir(arg: "\(destVolume)/\(appleSysLibPre)")
            }
            
            let kmArrA = ["create", "-n", "-boot", "--boot-path", "\(appleSysLibPre)", "-f", "'OSBundleRequired'=='Local-Root'", "--kernel", "/\(kernel)", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
            
            runIndeterminateProcess(binary: kmutil, arguments: kmArrA, title: "Updating Prelinked Kernel...")
            
            indicatorBump(updateProgBar: true)

        } else {
            
            let kmArrA = ["create", "-n", "-boot", "--boot-path", "/\(prelinkedkernel)", "-f", "'OSBundleRequired'=='Local-Root'", "--kernel", "/\(kernel)", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
            
            runIndeterminateProcess(binary: kmutil, arguments: kmArrA, title: "Updating Prelinked Kernel...")
            
            indicatorBump(updateProgBar: true)

            
        }
        
        runIndeterminateProcess(binary: kcditto, arguments: [], title: "Running kcditto...")
        
        indicatorBump(updateProgBar: true)

        
    }
    
}
