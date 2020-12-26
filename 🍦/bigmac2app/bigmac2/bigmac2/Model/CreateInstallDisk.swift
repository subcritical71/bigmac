//
//  CreateInstallDisk.swift
//  bigmac2
//
//  Created by starplayrx on 12/21/20.
//

import Foundation

extension ViewController {
    
    func downloadPkg() {
        //Remove pre-existing file
        _ = runCommandReturnString(binary: "/bin/rm", arguments: ["-Rf","/tmp/InstallAssistant.pkg"]) //Future check if it's complete and has right checksum
        
        DispatchQueue.global(qos: .background).async {
            self.download(urlString: "http://swcdn.apple.com/content/downloads/00/55/001-86606-A_9SF1TL01U7/5duug9lar1gypwunjfl96dza0upa854qgg/InstallAssistant.pkg")
        }
    }
    
    //MARK: Install Shared Support DMG
    internal func installSharedSupportDMG() {
        DispatchQueue.global(qos: .background).async { [self] in
            copyFile(atPath: "/Applications/Install macOS Big Sur.app/Contents/SharedSupport/SharedSupport.dmg", toPath: "/Volumes/macOS Base System/SharedSupport.dmg")
        }
    }
    
    //MARK: Increment Install Fuel Gauge
    internal func incrementInstallGauge(resetGauge: Bool, incremment: Bool, setToFull: Bool) {
        
        DispatchQueue.main.async { [self] in
            
            if resetGauge {
                installerFuelGauge.doubleValue = installerFuelGauge.minValue
            }
            
            if incremment {
                installerFuelGauge.doubleValue += 1
            }
            
            if setToFull {
                installerFuelGauge.doubleValue = installerFuelGauge.maxValue
            }
        }
    }
    
    //MARK: Increment Install Fuel Gauge
    internal func setMediaLabel(_ message: String) {
        
        DispatchQueue.main.async { [self] in
            mediaLabel.stringValue = message
        }
    }
    
    //MARK: Spinner Animation
    internal func spinnerAnimation (start: Bool, hide: Bool) {
        
        DispatchQueue.main.async { [self] in
            if start {
                createInstallSpinner.startAnimation(self)
            } else {
                createInstallSpinner.stopAnimation(self)
            }
            
            if hide {
                createInstallSpinner.isHidden = true
            } else {
                createInstallSpinner.isHidden = false
            }
        }
        
    }
    
    //MARK: Check for root user
    internal func checkForRootUser () -> Bool {
        rootMode || NSUserName() == "root" ? true : false
    }
    
    //MARK: Make Directory - To do use File Manager (For alot of these future tasks)
    internal func mkDir(bin: String = "/bin/mkdir", arg: String) -> String {
        let result = runCommandReturnString(binary: bin , arguments: [arg]) ?? ""
        return result
    }
    
    //MARK: Make Rename Disk using diskutil
    internal func renameDisk(bin: String = "/usr/sbin/diskutil", input: String, output: String) -> String {
        let result = runCommandReturnString(binary: bin , arguments: ["rename", input, output]) ?? ""
        return result
    }
    
    
    //diskutil apfs deleteVolume /Volumes/bm2tmp0
    
    //MARK: Make Rename Disk using diskutil
    internal func removeApfsVolume(bin: String = "/usr/sbin/diskutil", remove: String) -> String {
        let result = runCommandReturnString(binary: bin , arguments: ["apfs", "deleteVolume", remove]) ?? ""
        return result
    }
    
    //MARK: Make Rename Disk using diskutil
    internal func blessVolume(bin: String = "/usr/sbin/bless", bless: String) -> String {
        let result = runCommandReturnString(binary: bin , arguments: ["--mount", "/Volumes/\(bless)"]) ?? ""
        return result
    }
    
    //MARK: File String
    func parseRawText(_ str: String) -> String {
        
        var s = str
        
        s = s.replacingOccurrences(of: "\t", with: " ")

        for _ in 1...3 {
            s = s.replacingOccurrences(of: "     ", with: " ")
            s = s.replacingOccurrences(of: "    ", with: " ")
            s = s.replacingOccurrences(of: "   ", with: " ")
            s = s.replacingOccurrences(of: "  ", with: " ")
        }
    
        return s

    }
    //MARK: Mount diskimage and parse disk#s#
    internal func mountDiskImage(bin: String = "/usr/bin/hdiutil", arg: [String]) -> String {
            
        var mountedDisk = runCommandReturnString(binary: bin , arguments: arg) ?? ""
        mountedDisk = parseRawText(mountedDisk)
    
        return mountedDisk
    }
    
    //MARK: Extract DMG from Zip file
    func extractDMGfromZip(bin: String = "/usr/bin/unzip", arg: [String] ) -> String {
        let result = runCommandReturnString(binary: bin , arguments: arg) ?? ""
        return result
    }
    
    //MARK: Add volume using ASR
    func addVolume(binStr: String = "/usr/sbin/asr", dmgPath: String, targetDisk: String, erase: Bool, title: String) -> String {
        var eraseString = ""
      
        var args = ["--source", dmgPath, "--target", targetDisk, "-noverify", "-noprompt", "--puppetstrings"]
        
        if erase {
            eraseString = "-erase"
            args.append(eraseString)
        }
        
        runProcess(binary: "/usr/sbin/asr", arguments: args, title: title)
        
        return "Done"
    }
    
    
    func eraseDisk(bin: String = "/usr/sbin/diskutil", diskSlice: String ) -> String {
        let result = runCommandReturnString(binary: bin, arguments: ["reformat", diskSlice]) ?? ""
        return result
    }
    
    func mountVolume(bin: String = "/usr/sbin/diskutil", disk: String) -> String {
        //diskutil mountDisk disk9
        let result = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["mountDisk", disk]) ?? ""
        return result
    }
    
    //MARK: Get Disk Info by a single Disk with all volumes it contains, plus filtering specific disk and get its slice
    func getVolumeInfoByDisk (filterVolumeName: String, disk: String) -> myVolumeInfo? {
        
        let volInfo = getVolumeInfo(includeHiddenVolumes: true)
            
        if disk != "" {
            let disks = volInfo?.filter { $0.disk == disk }
            let d = disks?.filter { $0.volumeName == filterVolumeName }
            return d?.first ?? nil
        } else {
            let d = volInfo?.filter { $0.volumeName == filterVolumeName }
            return d?.first ?? nil
        }
  
        
        return nil
    }
    
    //MARK: Get APFS Physical Store Disk:
    func getApfsPhysicalStoreDisk(apfsDiskInfo: String ) -> String {
        
        let apfsStringData = parseRawText(apfsDiskInfo)
        
        let array = apfsStringData.components(separatedBy: "\n")
        let ac = array.count

        if ac >= 11 {
            let array2 = array[10].components(separatedBy: " ")
            let disk = array2.last
            
            let getWholeDisk = disk?.components(separatedBy: "s")
            
            var forgeDisk = ""
            if let getDisk = getWholeDisk, getDisk.count >= 2, let di = Optional(getDisk[0]), let kNum = Optional(getDisk[1]) {
                forgeDisk = "\(di)s\(kNum)"
            }
            
            return forgeDisk
        } else {
            return ""
        }
    }
    
    
    func unmountDrives() {
        let binary = "/usr/sbin/diskutil"
        let unmount = "unmount"
        
        let disks = ["Preboot","Recovery","macOS Base System","SharedSupport"]
        
        for disk in disks {
            _ = runCommandReturnString( binary: binary, arguments: [ unmount, disk ] ) ?? ""

        }
  
    }
    
    //MARK: Install Disk Setup
    func disk(isBeta:Bool, diskInfo: myVolumeInfo) {
        
        unmountDrives()
        
        _ = runCommandReturnString(binary: "/usr/sbin/installer" , arguments: ["-allowUntrusted", "-pkg", "/Users/Shared/InstallAssistant.pkg", "-target", "/" ]) ?? ""
        


        incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)

        let fm = FileManager.default

        let tmp = "tmp"
        let sharedsupport = "SharedSupport"
        let bigmac2 = "bigmac2"
        let tempDiskImage = "bm2tmp0"
        
        let applications = "Applications"
        let basesystem = "BaseSystem"
        let appFolder = Bundle.main.resourceURL
        let tempSystem = "\(appFolder!.path)/\(tempDiskImage).dmg"
        let macSoftwareUpdate = "com_apple_MobileAsset_MacSoftwareUpdate"
        var installBigSur = "Install macOS Big Sur.app"
        let wildZip = "*.zip"
        let restoreBaseSystem = "AssetData/Restore/\(basesystem).dmg"
        
        if isBeta {
            installBigSur = "Install macOS Big Sur Beta.app"
        }
        
        DispatchQueue.global(qos: .background).async { [self] in
            

            
            incrementInstallGauge(resetGauge: true, incremment: false, setToFull: false)
            spinnerAnimation(start: true, hide: false)
               
            //MARK: Erase disk inplace using reformat
            let resultReformatDisk = eraseDisk(diskSlice: diskInfo.diskSlice)
            /*
             
             Started erase
             Preparing to erase APFS Volume content
             Checking mount state
             Erasing APFS Volume disk5s1 by deleting and re-adding
             Deleting APFS Volume from its APFS Container
             Unmounting disk5s1
             Erasing any xART session referenced by 9AF622B2-675E-43F6-BD33-B1A83BE66156
             Deleting Volume
             Removing any Preboot and Recovery Directories
             Preparing to add APFS Volume to APFS Container disk5
             Creating APFS Volume
             Created new APFS Volume disk5s1
             Setting mount state
             Setting volume permissions
             Finished erase
             
             */
            
            //let apfsFormat = resultReformatDisk.contains("Created new APFS Volume") ? true : false
            
            //MARK: If reformat failed because it's not APFS then erase the whole disk (Not a good idea, we will let the user handle it)
            /*if !apfsFormat {
                //diskutil apfs list disk9 | grep "APFS Physical Store Disk" | awk '{printf $6}'
                let apfsDiskInfo = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["apfs", "list", "\(diskInfo.disk)" ]) ?? ""
                let apfsPhysicalStoreDisk = getApfsPhysicalStoreDisk(apfsDiskInfo: apfsDiskInfo)
                if apfsPhysicalStoreDisk.contains("disk") {
                    let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["eraseDisk", "apfs", "\(diskInfo.volumeName)","\(apfsPhysicalStoreDisk)" ] )
                } else {
                    let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["eraseDisk", "apfs", "\(diskInfo.volumeName)","\(diskInfo.disk)" ] )
                }
            } else {
                let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["eraseDisk", "apfs", "\(diskInfo.volumeName)","\(diskInfo.disk)" ] )
            }*/
             
            //MARK: Inc Format
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
            
            //MARK: make temp dir SharedSupport
            let _ = mkDir(arg: "/\(tmp)/\(sharedsupport)")
            
            //MARK: mount disk idmage inside temp SharedSupport
            let _ = mountDiskImage(arg: ["mount", "-mountPoint", "/\(tmp)/\(sharedsupport)", "/\(applications)/\(installBigSur)/Contents/\(sharedsupport)/\(sharedsupport).dmg", "-noverify", "-noautoopen", "-noautofsck", "-nobrowse"])
            
            //MARK: Zip Extraction (retain base system disk image from DMG)
            let _ = extractDMGfromZip(arg: ["-o", "/\(tmp)/\(sharedsupport)/\(macSoftwareUpdate)/\(wildZip)", "\(restoreBaseSystem)", "-d", "/\(tmp)"])
            
            //MARK: Mounted Shared Support DMG and Extracted DMG from zip
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
            
            let _ = addVolume(dmgPath: tempSystem, targetDisk: "/dev/r\(diskInfo.disk)", erase: true, title: "Creating Directory")
        
            //MARK: Created Temp Directory
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
            
            //MARK: Install Base System
            let _ = addVolume(dmgPath: "/\(tmp)/\(restoreBaseSystem)", targetDisk: "/dev/r\(diskInfo.disk)", erase: false, title: "Installing Base System")
            
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)

            let _ = mountVolume(disk: diskInfo.disk)
            let _ = renameDisk(input: "macOS Base System", output: "bigmac2")
            let rndStr = String(Int.random(in: 1000...9999))

            
            //MARK: make temp dir SharedSupport
            let _ = mkDir(arg: "/\(tmp)/\(basesystem)\(rndStr)")
            let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["unmount", "/\(tmp)/\(restoreBaseSystem)"] )

            //MARK: mount disk idmage inside temp SharedSupport
            

            let _ = mountDiskImage(arg: ["mount", "-mountPoint", "/\(tmp)/\(basesystem)\(rndStr)", "/\(tmp)/\(restoreBaseSystem)", "-nobrowse", "-noautoopen", "-noverify"])
            let getBaseSystemDisk = getVolumeInfoByDisk(filterVolumeName: "/private/\(tmp)/\(basesystem)\(rndStr)", disk: "")
            let getPrebootDisk = (getBaseSystemDisk!.disk + "s2")
            
            let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["unmount", "\(getPrebootDisk)"] )

            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)

            //MARK: make temp dir SharedSupport
            let _ = mkDir(arg: "/\(tmp)/prebootbs\(rndStr)")
            let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["mount", "-mountPoint", "/private/\(tmp)/prebootbs\(rndStr)", "\(getPrebootDisk)"] )
            
            //MARK: make temp dir SharedSupport
            let _ = mkDir(arg: "/\(tmp)/prebootdest\(rndStr)")
            
            
            
            
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)

            if let bm2tmp = getVolumeInfoByDisk(filterVolumeName: "bm2tmp0", disk: diskInfo.disk), let bigmac2 = getVolumeInfoByDisk(filterVolumeName: "bigmac2", disk: diskInfo.disk) {
                let prebootDest = "\(diskInfo.disk)s2" //cheat
                let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["mount", "\(prebootDest)"] )
                let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["mount", bigmac2.diskSlice] )
                
                let _ = runCommandReturnString(binary: "/sbin/mount" , arguments: ["-uw", "/Volumes/\(bigmac2.volumeName)"])

                sleep(1)
                
                //MARK: Just did a bunch of prep work
                if let itemsToCopy = try? fm.contentsOfDirectory(atPath:  "/private/\(tmp)/prebootbs\(rndStr)/") {
                    for i in itemsToCopy {
                        try? fm.copyItem(atPath: "/private/\(tmp)/prebootbs\(rndStr)/\(i)", toPath: "/Volumes/Preboot/\(i)")
                        try? fm.moveItem(atPath: "/Volumes/Preboot/\(i)", toPath: "/Volumes/Preboot/\(bigmac2.uuid)")

                    }
                }
                
                ///Users/starplayrx/Documents/GitHub/bigmac/🍦/bigmac2app/bigmac2/Data/com.apple.Boot.plist

                //MARK: Make Preboot bootable and compatible with C-Key at boot time
                if let appFolder = Bundle.main.resourceURL {
                    let bootPlist = "com.apple.Boot.plist"
                    let platformPlist = "BuildManifest.plist"
                    let buildManifestPlist = "PlatformSupport.plist"

                    let appFolderPath = "\(appFolder.path)"
            
                    //Install Boot plist
                    
                    let _ = mkDir(arg: "/Volumes/Preboot/\(bigmac2.uuid)/restore/")

                    print("\nMaking System Disk Bootable...\n")
                    try? fm.removeItem(atPath: "/Volumes/Preboot/\(bigmac2.uuid)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                    try? fm.removeItem(atPath: "/Volumes/Preboot/\(bigmac2.uuid)/System/Library/CoreServices/\(platformPlist)")
                    try? fm.removeItem(atPath: "/Volumes/Preboot/\(bigmac2.uuid)/restore/\(buildManifestPlist)")
                    
                    try? fm.copyItem(atPath: "/\(appFolderPath)/\(bootPlist)", toPath: "/Volumes/Preboot/\(bigmac2.uuid)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                    try? fm.copyItem(atPath: "/\(appFolderPath)/\(bootPlist)", toPath: "/Volumes/Preboot/\(bigmac2.uuid)/System/Library/CoreServices/\(platformPlist)")
                    try? fm.copyItem(atPath: "/\(appFolderPath)/\(bootPlist)", toPath: "/Volumes/Preboot/\(bigmac2.uuid)/restore/\(buildManifestPlist)")
                
                }
               

                _ = blessVolume(bless: bigmac2.volumeName)
               
                

                incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
                
                _ = removeApfsVolume(remove: bm2tmp.volumeName)

            }

                
                
            setMediaLabel("Big Sur Installer App Transfer")
            
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
            
            
         

            
            let _ = mkDir(arg: "/Volumes/bigmac2/Install macOS Big Sur.app/Contents/SharedSupport/")
            copyFile(atPath: "/Applications/Install macOS Big Sur.app/Contents/SharedSupport/SharedSupport.dmg", toPath: "/Volumes/bigmac2/Install macOS Big Sur.app/Contents/SharedSupport/SharedSupport.dmg")
            
            unmountDrives()
            
            incrementInstallGauge(resetGauge: false, incremment: false, setToFull: true)
            spinnerAnimation(start: false, hide: true)

            
        }
    }
    
}


