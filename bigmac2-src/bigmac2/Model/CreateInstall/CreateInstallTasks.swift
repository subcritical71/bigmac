//
//  CreateInstallTasks.swift
//  bigmac2
//
//  Created by starplayrx on 12/30/20.
//

import Foundation


extension ViewController {
    
    //MARK: Task #1
    func updateInstallerPkg(){
        _ = runCommandReturnString(binary: "/usr/sbin/installer" , arguments: ["-allowUntrusted", "-pkg", "/Users/Shared/InstallAssistant.pkg", "-target", "/" ]) ?? ""
        
        incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
    }
    
    
    
    //MARK: Task #2
    func reformatSelectedApfsDisk(diskInfo: myVolumeInfo) {
        //MARK: Erase disk inplace using reformat
        _ = eraseDisk(diskSlice: diskInfo.diskSlice)
        incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
    }
    
    
    
    //MARK: Task #3
    func extractBaseSystem() {
        //MARK: make temp dir SharedSupport
        _ = mkDir(arg: "/\(tmp)/\(sharedsupport)")
        
        //MARK: mount disk idmage inside temp SharedSupport
        _ = mountDiskImage(arg: ["mount", "-mountPoint", "/\(tmp)/\(sharedsupport)", "/\(applications)/\(installBigSur)/Contents/\(sharedsupport)/\(sharedsupport).dmg", "-noverify", "-noautoopen", "-noautofsck", "-nobrowse"])
        
        //MARK: Zip Extraction (retain base system disk image from DMG)
        _ = extractDMGfromZip(arg: ["-o", "/\(tmp)/\(sharedsupport)/\(macSoftwareUpdate)/\(wildZip)", "\(restoreBaseSystem)", "-d", "/\(tmp)"])
        
        //MARK: Mounted Shared Support DMG and Extracted DMG from zip
        incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
        
        _ = mountDiskImage(arg: ["unmount", "/\(tmp)/\(sharedsupport)", "-force"])
        
        
    }
    
    
    
    //MARK: Task #4
    func createDirectory(diskInfo: myVolumeInfo, disk: String, rndStr: String) {
        
        for _ in 1...3 {
            let result = addVolume(dmgPath: tempSystem, targetDisk: "/dev/r\(diskInfo.disk)", erase: true, title: "Creating Directory")
            if result == "Done" { break }
            sleep(2)
        }
        
        incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
        let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["mount", disk] )
        sleep(2)
        let _ = renameDisk(input: disk, output: "\(disk)_\(rndStr)")
    }
    
    
    
    //MARK: Task #5
    func installBaseSystem(diskInfo: myVolumeInfo, baseSys: String, bm2: String) {
        //MARK: Install Base System
        _ = addVolume(dmgPath: "/\(tmp)/\(restoreBaseSystem)", targetDisk: "/dev/r\(diskInfo.disk)", erase: false, title: "Installing Base System")
        
        _ = mountDiskImage(arg: ["unmount", "/\(tmp)/\(restoreBaseSystem)", "-force"])
        
        _ = mountVolume(disk: diskInfo.disk)
        _ = renameDisk(input: baseSys, output: bm2)
        
        incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
    }
    
    //MARK: Task #5.1
    func installBaseSystemII(diskInfo: myVolumeInfo, baseSys: String, bm2: String) {
        //MARK: Install Base System
        
        let path = "/Users/shared/\(bigmacDisk)"
        let ttle = "Installing the bigmac2 Boot Disk..."
        
        if checkIfFileExists(path: path) {
            _ = addVolume(dmgPath: "/Users/shared/\(bigmacDisk)", targetDisk: "/dev/r\(diskInfo.disk)", erase: true, title: ttle)
        } else {
            print("BASE SYSTEM... DISK NOT FOUND...\n")
        }
                
        _ = mountVolume(disk: diskInfo.disk)
        
        incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false, cylon: false, title: ttle)
    }
    
    
    
    //MARK: Task #6 (For Admin - This needs to be refactor and utilize the common BootSystem routine)
    func setupPreboot(diskInfo: myVolumeInfo, bm2: String, rndStr: String, isVerbose: Bool, isSingleUser: Bool, slice: String) {
        let _ = mkDir(arg: "/\(tmp)/\(basesystem)\(rndStr)")
        let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["unmount", "/\(tmp)/\(restoreBaseSystem)"] )
        let _ = mountDiskImage(arg: ["mount", "-mountPoint", "/\(tmp)/\(basesystem)\(rndStr)", "/\(tmp)/\(restoreBaseSystem)", "-nobrowse", "-noautoopen", "-noverify"])
        
        if let getBaseSystemDisk = getVolumeInfoByDisk(filterVolumeName: "/private/\(tmp)/\(basesystem)\(rndStr)", disk: "") {
            let getPrebootDisk = (getBaseSystemDisk.disk + slice)
            
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["unmount", "\(getPrebootDisk)"] )
            
            _ = mkDir(arg: "/\(tmp)/prebootbs\(rndStr)")
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["mount", "-mountPoint", "/private/\(tmp)/prebootbs\(rndStr)", "\(getPrebootDisk)"] )
            
            _ = mkDir(arg: "/\(tmp)/prebootdest\(rndStr)")
            
            
            if let bm2tmp = getVolumeInfoByDisk(filterVolumeName: "bm2tmp0_\(rndStr)", disk: diskInfo.disk), let bigmac2 = getVolumeInfoByDisk(filterVolumeName: bm2, disk: diskInfo.disk) {
                let prebootDest = "\(diskInfo.disk)s2" //cheat
                
                let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["mount", "\(prebootDest)"] )
                let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["mount", bigmac2.diskSlice] )
                let _ = runCommandReturnString(binary: "/sbin/mount" , arguments: ["-uw", "/Volumes/\(bigmac2.volumeName)"])
                
                //MARK: Just did a bunch of prep work
                if let itemsToCopy = try? fm.contentsOfDirectory(atPath:  "/private/\(tmp)/prebootbs\(rndStr)/") {
                    for i in itemsToCopy {
                        try? fm.copyItem(atPath: "/private/\(tmp)/prebootbs\(rndStr)/\(i)", toPath: "/Volumes/Preboot/\(i)")
                        try? fm.moveItem(atPath: "/Volumes/Preboot/\(i)", toPath: "/Volumes/Preboot/\(bigmac2.uuid)")
                    }
                }
            
                //MARK: Make Preboot bootable and compatible with C-Key at boot time
                if let appFolder = Bundle.main.resourceURL {
                    let bootPlist = "com.apple.Boot.plist"
                    let platformPlist = "BuildManifest.plist"
                    let buildManifestPlist = "PlatformSupport.plist"
                    
                    let appFolderPath = "\(appFolder.path)"
                    
                    //Install Boot plist
                    
                    let _ = mkDir(arg: "/Volumes/Preboot/\(bigmac2.uuid)/restore/")
                    
                    try? fm.removeItem(atPath: "/Volumes/Preboot/\(bigmac2.uuid)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                    try? fm.removeItem(atPath: "/Volumes/Preboot/\(bigmac2.uuid)/System/Library/CoreServices/\(platformPlist)")
                    try? fm.removeItem(atPath: "/Volumes/Preboot/\(bigmac2.uuid)/restore/\(buildManifestPlist)")
                    
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
                    txt2file(text: bootPlistTxt, file: "/Volumes/Preboot/\(bigmac2.uuid)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                    try? fm.copyItem(atPath: "/\(appFolderPath)/\(platformPlist)", toPath: "/Volumes/Preboot/\(bigmac2.uuid)/System/Library/CoreServices/\(platformPlist)")
                    try? fm.copyItem(atPath: "/\(appFolderPath)/\(buildManifestPlist)", toPath: "/Volumes/Preboot/\(bigmac2.uuid)/restore/\(buildManifestPlist)")
                }
                
                _ = removeApfsVolume(remove: bm2tmp.volumeName)
                _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["unmount", "\(getPrebootDisk)"] )
            }
        }
                
        incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
    }
    
    
    
    //MARK: Task #7
    func bigSurInstallerAppXfer(rndStr: String) {
        let _ = mkDir(arg: "/Volumes/\(bigmac2)/Install macOS Big Sur.app/Contents/SharedSupport/")
        copyFile(atPath: "/Applications/Install macOS Big Sur.app/Contents/SharedSupport/SharedSupport.dmg", toPath: "/Volumes/\(bigmac2)/Install macOS Big Sur.app/Contents/SharedSupport/SharedSupport.dmg")
    }
    
    
    func installTheApp(bigmac2: myVolumeInfo) {
        
        if let bigmac2 = getVolumeInfoByDisk(filterVolumeName: bigmac2.volumeName, disk: bigmac2.disk) {
            //MARK: Make Preboot bootable and compatible with C-Key at boot time
            if let appFolder = Bundle.main.resourceURL  {
                                
                let appFolderPath = "\(appFolder.path)"
                let bigMacApp = Bundle.main.bundlePath
                
                let burgerKing = bigmac2.volumeName
                
                let util = "/Volumes/\(burgerKing)/System/Installation/CDIS/Recovery Springboard.app/Contents/Resources/Utilities.plist"
                let bk = "/Volumes/\(burgerKing)/Applications/bigmac2.app"
                let rdm = "/Volumes/\(burgerKing)/Applications/RDM.app"

                try? fm.removeItem(atPath: util)
                try? fm.removeItem(atPath: bk)
                try? fm.removeItem(atPath: rdm)

                try? fm.copyItem(atPath: "/\(appFolderPath)/Utilities.plist", toPath: util)
                try? fm.copyItem(atPath: "\(bigMacApp)", toPath: bk)
                try? fm.copyItem(atPath: "/\(appFolderPath)/RDM.app", toPath: rdm)
                
                //copyFile(atPath: "\(bigMacApp)", toPath: bk)
            }
        }
    }
    
    
    //MARK: Task #8
    func cleanup(bm2: String, rndStr: String) {
        
        let bigmac2 = bm2.replacingOccurrences(of: "_\(rndStr)", with: "")

        _ = renameDisk(input: bm2, output: bigmac2)
        _ = blessVolume(bless: bigmac2)
        
        if let getBaseSystemDisk = getVolumeInfoByDisk(filterVolumeName: "/private/\(tmp)/\(basesystem)\(rndStr)", disk: "") {
            let infoDisc = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["apfs", "list", "\(getBaseSystemDisk.disk)"] ) ?? ""
            
            if !infoDisc.isEmpty {
                let wholeDisk = getApfsPhysicalStoreDisk(apfsDiskInfo: infoDisc)
                _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["eject", wholeDisk] ) ?? ""
            }
        }

        _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["eject", "Shared Support"] )
        
        incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
    }
}
