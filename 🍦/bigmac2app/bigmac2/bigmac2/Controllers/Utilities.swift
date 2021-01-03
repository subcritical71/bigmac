//
//  Utilities.swift
//  bigmac2
//
//  Created by starplayrx on 1/1/21.
//

import Cocoa

// MARK: - System Info code
struct systemInfoCodable: Codable {
    let productVersion, productBuildVersion, productCopyright, productName: String
    let iOSSupportVersion, productUserVisibleVersion: String
    
    enum CodingKeys: String, CodingKey {
        case productVersion = "ProductVersion"
        case productBuildVersion = "ProductBuildVersion"
        case productCopyright = "ProductCopyright"
        case productName = "ProductName"
        case iOSSupportVersion
        case productUserVisibleVersion = "ProductUserVisibleVersion"
    }
}

extension ViewController {
    
    // MARK: Get System Info
    func getSystemInfo(drive:String) -> systemInfoCodable?   {
        
        let systemPath = "/Volumes/\(drive)/System/Library/CoreServices/SystemVersion.plist"
        //let systemURL = NSURL(string: systemPath)
        let systemURL = URL(fileURLWithPath: systemPath)
        var systemInfo : systemInfoCodable?
        do {
            
        
            let data = try Data(contentsOf: systemURL )
            let decoder = PropertyListDecoder()
            systemInfo = try decoder.decode(systemInfoCodable.self, from: data)
            
            return systemInfo
        } catch {
            // Handle error
            print(error)
        }
        
        return nil
        
    }
    
    func disableSetResXButtonsCheck() {
        if !fm.fileExists(atPath: setResX) {
            LowRes_720.isHidden = true
            HiRes_720.isHidden = true
            LowRes_1080.isHidden = true
            HiRes_1080.isHidden = true
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
                    print ( majorMinorVersion, i.displayName, i.root )
                    availablePatchDisks.addItem(withTitle: drive)
                }
            }
        }
    }
    
    //Gather checboxes
    func patchBool() {
        enableUSB       = (enableUSB_btn.state == .on)
        disableBT2      = (disableBT2_btn.state == .on)
        amdMouSSE       = (amdMouSSE_btn.state == .on)
        teleTrap        = (teleTrap_btn.state == .on)
        VerboseBoot     = (VerboseBoot_btn.state == .on)
        superDrive      = (superDrive_btn.state == .on)
        appleHDA        = (appleHDA_btn.state == .on)
        hdmiAudio       = (hdmiAudio_btn.state == .on)
        appStoreMacOS   = (appStoreMacOS_btn.state == .on)
        singleUser      = (singleUser_btn.state == .on)
        legacyWiFi      = (legacyWiFi_btn.state == .on)
    }
    
    
    func installKext(dest: String, kext: String, fold: String, prfx: String = "") -> Bool {
        var strg = ""
        let fail = "Do not pass"
        var pass = false
        let copy = "Copying"
        
        if let source = Bundle.main.resourceURL?.path {
            let destiny = "\(dest)/\(fold)/\(kext)"
            let mdir = "\(dest)/\(fold)/"
            
            
            print("")
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
        
        
        postInstallFuelGauge.doubleValue += 1

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
    func BootSystem(system: myVolumeInfo, dataVolumeUUID: String, isVerbose: Bool, isSingleUser: Bool, prebootVolume : String) {
        
        //MARK: Make Preboot bootable and compatible with C-Key at boot time
        if let appFolder = Bundle.main.resourceURL {
            
            //Get Preboot Ready
            let prebootPath = "/tmp/\(prebootVolume)"
            
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["unmount", "force", prebootVolume])
            
            if !system.root {
                _ = mkDir(arg:prebootPath)
                _ = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["mount", "-mountPoint", prebootPath, prebootVolume])
            }
            
            // diskutil mount -mountPoint /tmp/disk4s2 disk4s2
            let bootPlist = "com.apple.Boot.plist"
            let platformPlist = "PlatformSupport.plist"
            let buildManifestPlist = "BuildManifest.plist"
            
            let appFolderPath = "\(appFolder.path)"
            
            print("Making System Disk Bootable...\n")
            
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
            
            if system.root {
                try? fm.removeItem(atPath: "\(system.path)Library/Preferences/SystemConfiguration/\(bootPlist)")
                try? fm.removeItem(atPath: "\(system.path)System/Library/CoreServices/\(platformPlist)")
                try? fm.removeItem(atPath: "\(system.path)System/Volumes/Preboot/\(dataVolumeUUID)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                try? fm.removeItem(atPath: "\(system.path)System/Volumes/Preboot/\(dataVolumeUUID)/System/Library/CoreServices/\(platformPlist)")
                try? fm.removeItem(atPath: "\(system.path)System/Volumes/Preboot/\(dataVolumeUUID)/restore/\(buildManifestPlist)")
                
            } else {
                try? fm.removeItem(atPath: "\(system.path)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                try? fm.removeItem(atPath: "\(system.path)/System/Library/CoreServices/\(platformPlist)")
                try? fm.removeItem(atPath: "\(prebootPath)/\(dataVolumeUUID)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                try? fm.removeItem(atPath: "\(prebootPath)/\(dataVolumeUUID)/System/Library/CoreServices/\(platformPlist)")
                try? fm.removeItem(atPath: "\(prebootPath)/\(dataVolumeUUID)/restore/\(buildManifestPlist)")
            }
            
            if system.root {
                
                txt2file(text: bootPlistTxt, file:  "\(system.path)Library/Preferences/SystemConfiguration/\(bootPlist)")
                txt2file(text: bootPlistTxt, file:  "\(system.path)System/Volumes/Preboot/*/Library/Preferences/SystemConfiguration/\(bootPlist)")
                
                try? fm.copyItem(atPath: "/\(appFolderPath)/\(platformPlist)",       toPath: "\(system.path)System/Library/CoreServices/\(platformPlist)")
                try? fm.copyItem(atPath: "/\(appFolderPath)/\(platformPlist)",       toPath: "\(prebootPath)/\(dataVolumeUUID)/System/Library/CoreServices/\(platformPlist)")
                try? fm.copyItem(atPath: "/\(appFolderPath)/\(buildManifestPlist)",  toPath: "\(prebootPath)/\(dataVolumeUUID)/restore/\(buildManifestPlist)")
                
            } else {
                txt2file(text: bootPlistTxt, file:  "\(system.path)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                txt2file(text: bootPlistTxt, file:  "\(prebootPath)/\(dataVolumeUUID)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                
                try? fm.copyItem(atPath: "/\(appFolderPath)/\(platformPlist)",       toPath: "\(system.path)/System/Library/CoreServices/\(platformPlist)")
                try? fm.copyItem(atPath: "/\(appFolderPath)/\(platformPlist)",       toPath: "\(prebootPath)/\(dataVolumeUUID)/System/Library/CoreServices/\(platformPlist)")
                try? fm.copyItem(atPath: "/\(appFolderPath)/\(buildManifestPlist)",  toPath: "\(prebootPath)/\(dataVolumeUUID)/restore/\(buildManifestPlist)")
            }
            
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["unmount", "force", prebootVolume])
            
        }
    }
    
    
    //MARK: Update System - Preboot only
    func BaseSystem(dataVolume: myVolumeInfo, isVerbose: Bool, isSingleUser: Bool, prebootVolume : String) {
        
        //MARK: Make Preboot bootable and compatible with C-Key at boot time
        if let appFolder = Bundle.main.resourceURL {
            
            //Get Preboot Ready
            let prebootPath = "/tmp/\(prebootVolume)"
            
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["unmount", "force", prebootVolume])
            
            _ = mkDir(arg:prebootPath)
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["mount", "-mountPoint", prebootPath, prebootVolume])
            
            // diskutil mount -mountPoint /tmp/disk4s2 disk4s2
            let bootPlist = "com.apple.Boot.plist"
            let platformPlist = "PlatformSupport.plist"
            let buildManifestPlist = "BuildManifest.plist"
            
            let appFolderPath = "\(appFolder.path)"
            
            print("Making System Disk Bootable...\n")
            
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
            try? fm.removeItem(atPath: "\(prebootPath)/\(dataVolume.uuid)/Library/Preferences/SystemConfiguration/\(bootPlist)")
            try? fm.removeItem(atPath: "\(prebootPath)/\(dataVolume.uuid)/System/Library/CoreServices/\(platformPlist)")
            try? fm.removeItem(atPath: "\(prebootPath)/\(dataVolume.uuid)/restore/\(buildManifestPlist)")
            txt2file(text: bootPlistTxt, file:  "\(prebootPath)/\(dataVolume.uuid)/Library/Preferences/SystemConfiguration/\(bootPlist)")
            
            try? fm.copyItem(atPath: "/\(appFolderPath)/\(platformPlist)",       toPath: "\(prebootPath)/\(dataVolume.uuid)/System/Library/CoreServices/\(platformPlist)")
            try? fm.copyItem(atPath: "/\(appFolderPath)/\(buildManifestPlist)",  toPath: "\(prebootPath)/\(dataVolume.uuid)/restore/\(buildManifestPlist)")
            
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["unmount", "force", prebootVolume])
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
        
       // print(touch,kmutil, kcditto)
        
        let appleSysLibExists               = checkIfFileExists(path: "\(destVolume)\(appleSysLib)")
        let appleSysLibPreKernelsExists     = checkIfFileExists(path: "\(destVolume)\(appleSysLibPre)")
        print("appleSysLibExists", appleSysLibExists)
        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(appleSysLib)"])
        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(appleSysLibExt)"])
        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(sysLibExt)"])
        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(sysLibDriverExt)"])
        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(libExt)"])
        _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(libDriveExt)"])
        
        
       //MARK: Updating All Kernel Extensions
        let kmArrA = ["install", "--update-all", "--check-rebuild", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
        runIndeterminateProcess(binary: kmutil, arguments: kmArrA, title: "Updating All Kernel Extensions...")
        
        //MARK: Rechecking Extensions
        let kmArrRE = ["install", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
        runIndeterminateProcess(binary: kmutil, arguments: kmArrRE, title: "Rechecking Extensions...")
        
        //MARK: Updating Library Extensions
        let kmArrB = ["install", "--check-rebuild", "--repository", "/\(libExt)", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
        runIndeterminateProcess(binary: kmutil, arguments: kmArrB, title: "Updating Library Extensions...")
    
        if appleSysLibExists {
            
            if !appleSysLibPreKernelsExists {
                _ = mkDir(arg: "\(destVolume)/\(appleSysLibPre)")
            }
            
            let kmArrA = ["create", "-n", "-boot", "--boot-path", "\(appleSysLibPre)", "-f", "'OSBundleRequired'=='Local-Root'", "--kernel", "/\(kernel)", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
            
            runIndeterminateProcess(binary: kmutil, arguments: kmArrA, title: "Updating Prelinked Kernel...")
            
        } else {
            
            let kmArrA = ["create", "-n", "-boot", "--boot-path", "/\(prelinkedkernel)", "-f", "'OSBundleRequired'=='Local-Root'", "--kernel", "/\(kernel)", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
            
            runIndeterminateProcess(binary: kmutil, arguments: kmArrA, title: "Updating Prelinked Kernel...")
            
        }
        
        runIndeterminateProcess(binary: kcditto, arguments: [], title: "Running kcditto...")
        
    }
    
}
