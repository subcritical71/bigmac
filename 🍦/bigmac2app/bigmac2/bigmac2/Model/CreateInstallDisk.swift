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
        
        var args = ["restore", "--source", dmgPath, "--target", targetDisk, "-noverify", "-noprompt", "--puppetstrings"]
        
        if erase {
            eraseString = "-erase"
            args.append(eraseString)
        }
        
        runProcess(binary: "/usr/sbin/asr", arguments: args, title: title)
        
        return "Done"
    }
    
    //MARK: Erase Disk
    func eraseDisk(bin: String = "/usr/sbin/diskutil", diskSlice: String ) -> String {
        let result = runCommandReturnString(binary: bin, arguments: ["reformat", diskSlice]) ?? ""
        return result
    }
    
    //MARK: MountVolume
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
    
    //UnmountDrives
    func unmountDrives() {
        let binary = "/usr/sbin/diskutil"
        let unmount = "unmount"
        
        let disks = ["Preboot","Recovery"]
        
        
        for disk in disks {
            _ = runCommandReturnString( binary: binary, arguments: [ unmount, disk ] ) ?? ""
        }
    }
    
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
        print(tempSystem)
        print("/dev/r\(diskInfo.disk)")
        
        for i in 1...3 {
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
    
    
    //MARK: Task #6
    func setupPreboot(diskInfo: myVolumeInfo, bm2: String, rndStr: String) {
        let _ = mkDir(arg: "/\(tmp)/\(basesystem)\(rndStr)")
        let _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["unmount", "/\(tmp)/\(restoreBaseSystem)"] )
        let _ = mountDiskImage(arg: ["mount", "-mountPoint", "/\(tmp)/\(basesystem)\(rndStr)", "/\(tmp)/\(restoreBaseSystem)", "-nobrowse", "-noautoopen", "-noverify"])
        
        if let getBaseSystemDisk = getVolumeInfoByDisk(filterVolumeName: "/private/\(tmp)/\(basesystem)\(rndStr)", disk: "") {
            let getPrebootDisk = (getBaseSystemDisk.disk + "s2")
            
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
                    
                    print("\nMaking System Disk Bootable...\n")
                    try? fm.removeItem(atPath: "/Volumes/Preboot/\(bigmac2.uuid)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                    try? fm.removeItem(atPath: "/Volumes/Preboot/\(bigmac2.uuid)/System/Library/CoreServices/\(platformPlist)")
                    try? fm.removeItem(atPath: "/Volumes/Preboot/\(bigmac2.uuid)/restore/\(buildManifestPlist)")
                    
                    try? fm.copyItem(atPath: "/\(appFolderPath)/\(bootPlist)", toPath: "/Volumes/Preboot/\(bigmac2.uuid)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                    try? fm.copyItem(atPath: "/\(appFolderPath)/\(bootPlist)", toPath: "/Volumes/Preboot/\(bigmac2.uuid)/System/Library/CoreServices/\(platformPlist)")
                    try? fm.copyItem(atPath: "/\(appFolderPath)/\(bootPlist)", toPath: "/Volumes/Preboot/\(bigmac2.uuid)/restore/\(buildManifestPlist)")
                    
                }
                
                
                _ = removeApfsVolume(remove: bm2tmp.volumeName)
                _ = mountDiskImage(arg: ["unmount", "/\(tmp)/\(basesystem)", "-force"])
                _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["unmount", "\(getPrebootDisk)"] )
                
            }
        }
        
        incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
    }
    
    //MARK: Task #7
    func bigSurInstallerAppXfer(rndStr: String) {
        setMediaLabel("Big Sur Installer App Transfer")
        
        let _ = mkDir(arg: "/Volumes/bigmac2_\(rndStr)/Install macOS Big Sur.app/Contents/SharedSupport/")
        copyFile(atPath: "/Applications/Install macOS Big Sur.app/Contents/SharedSupport/SharedSupport.dmg", toPath: "/Volumes/bigmac2_\(rndStr)/Install macOS Big Sur.app/Contents/SharedSupport/SharedSupport.dmg")
    }
    
    //MARK: Task #8
    func cleanup(bm2: String, rndStr: String) {
        
        let bigmac2 = bm2.replacingOccurrences(of: "_\(rndStr)", with: "")

        _ = renameDisk(input: bm2, output: bigmac2)
        _ = blessVolume(bless: bigmac2)
        
        if let getBaseSystemDisk = getVolumeInfoByDisk(filterVolumeName: "/private/\(tmp)/\(basesystem)\(rndStr)", disk: "") {
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["unmount", "\(getBaseSystemDisk.disk)"] )
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["eject", "\(getBaseSystemDisk.disk)"] )
            let infoDisc = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["apfs", "list", "\(getBaseSystemDisk.disk)"] ) ?? ""
            
            if !infoDisc.isEmpty {
                let wholeDisk = getApfsPhysicalStoreDisk(apfsDiskInfo: infoDisc)
                print("Eject \(wholeDisk)")
                _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["apfs", "eject", wholeDisk] ) ?? ""
            }
            
    

        
        }

        if let getSharedSupportDisk = getVolumeInfoByDisk(filterVolumeName: "/private/\(tmp)/\(sharedsupport)", disk: "") {
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["unmount", "\(getSharedSupportDisk.disk)"] )
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["eject", "\(getSharedSupportDisk.disk)"] )
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil" , arguments: ["eject", "Shared Support"] )

        }
        
        
        incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)

    }
    
    //MARK: Install Disk Setup
    func disk(isBeta:Bool, diskInfo: myVolumeInfo) {
        DispatchQueue.global(qos: .background).async { [self] in
            
            //MARK: Set vars and local constants
            if isBeta {
                installBigSur = "Install macOS Big Sur Beta.app"
            }
            
            let rndStr = String(Int.random(in: 100...999))
            let baseSys = "macOS Base System"
            let bm2 = "bigmac2_\(rndStr)"
            
            //MARK: Start
            incrementInstallGauge(resetGauge: true, incremment: false, setToFull: false)
            spinnerAnimation(start: true, hide: false)
            
            //MARK: Rev Engine
            unmountDrives()
            
            //MARK: Step 1
            updateInstallerPkg()
            
            //MARK: Step 2
            reformatSelectedApfsDisk(diskInfo: diskInfo)
            
            //MARK: Step 3
            extractBaseSystem()
            
            //MARK: Step 4
            createDirectory(diskInfo: diskInfo, disk: "bm2tmp0", rndStr: rndStr)
            
            //MARK: Step 5
            installBaseSystem(diskInfo: diskInfo, baseSys: baseSys, bm2: bm2)
            
            //MARK: Step 6
            setupPreboot(diskInfo: diskInfo, bm2: bm2, rndStr: rndStr)
          
            //MARK: Step 7
            //bigSurInstallerAppXfer(rndStr: rndStr)
            
            //MARK: Rev Engine
            unmountDrives()
            
            //MARK: Step 8 cleanup
            cleanup(bm2: bm2, rndStr: rndStr)
       
            //MARK: Finish
            incrementInstallGauge(resetGauge: false, incremment: false, setToFull: true)
            spinnerAnimation(start: false, hide: true)
        }
    }
    
}


