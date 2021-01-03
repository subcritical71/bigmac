//
//  CreateInstallDisk.swift
//  bigmac2
//
//  Created by starplayrx on 12/21/20.
//

import Foundation

extension ViewController {
    
    //MARK: To do - Setup a variable
    func downloadPkg() {
        //Remove pre-existing file
        _ = runCommandReturnString(binary: "/bin/rm", arguments: ["-Rf","/Users/shared/InstallAssistant.pkg"]) //Future check if it's complete and has right checksum
        _ = runCommandReturnString(binary: "/bin/rm", arguments: ["-Rf","/tmp/InstallAssistant.pkg"]) //Future check if it's complete and has right checksum
        
        DispatchQueue.main.async { [self] in
            downloadLabel.stringValue = "macOS 11.1"
        }

        DispatchQueue.global(qos: .background).async {
            self.download(urlString: "http://swcdn.apple.com/content/downloads/00/55/001-86606-A_9SF1TL01U7/5duug9lar1gypwunjfl96dza0upa854qgg/InstallAssistant.pkg")
        }
    }
    
    
    //MARK: To do - Setup a variable
    func downloadBigMac2(dmg: String) {
        //Remove pre-existing file
        _ = runCommandReturnString(binary: "/bin/rm", arguments: ["-Rf","/Users/shared/bigmac2.dmg"]) //Future check if it's complete and has right checksum
        _ = runCommandReturnString(binary: "/bin/rm", arguments: ["-Rf","/tmp/bigmac2.dmg"]) //Future check if it's complete and has right checksum
        
        DispatchQueue.main.async { [self] in
            downloadLabel.stringValue = "Fetching boot disk"
        }
        
        DispatchQueue.global(qos: .background).async {
            self.download(urlString: dmg)
        }
    }
    
    
    //MARK: Install Shared Support DMG
    internal func installSharedSupportDMG2() {
        DispatchQueue.global(qos: .background).async { [self] in
           copyFile(atPath: "/Applications/Install macOS Big Sur.app/Contents/SharedSupport/SharedSupport.dmg", toPath: "/Volumes/macOS Base System/SharedSupport.dmg")
        }
    }
    
    //MARK: Install Emoji Font
    internal func installEmojiFont(bm2: String) {
        DispatchQueue.global(qos: .background).async { [self] in
            copyFile(atPath: "/System/Library/Fonts/Apple Color Emoji.ttc", toPath: "/Volumes/\(bm2)/System/Library/Fonts/Apple Color Emoji.ttc")
        }
    }
    
    //MARK: Increment Install Fuel Gauge
    internal func incrementInstallGauge(resetGauge: Bool, incremment: Bool, setToFull: Bool, cylon: Bool = false, title: String = "") {
        
        DispatchQueue.main.async { [self] in
            if cylon {
                sharedSupportProgressBar.startAnimation(self)
            } else {
                sharedSupportProgressBar.stopAnimation(self)
                sharedSupportProgressBar.isIndeterminate = false
                sharedSupportProgressBar.doubleValue = 0
                sharedSupportProgressBar.minValue = 0
                sharedSupportProgressBar.maxValue = 100
            }
            
            if resetGauge {
                installerFuelGauge.doubleValue = installerFuelGauge.minValue
            }
            
            if incremment {
                installerFuelGauge.doubleValue += 1
            }
            
            if setToFull {
                installerFuelGauge.doubleValue = installerFuelGauge.maxValue
            }
            
            if !title.isEmpty {
                self.mediaLabel.stringValue = title
            }
           
        }
        
        if (!title.isEmpty) {
            sleep(1)
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
        let result = runCommandReturnString(binary: bin , arguments: ["--mount", "/Volumes/\(bless)", "--label", bless]) ?? ""
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
    func getVolumeInfoByDisk (filterVolumeName: String, disk: String, isRoot: Bool = false) -> myVolumeInfo? {
        
        let volInfo = getVolumeInfo(includeHiddenVolumes: true, includeRootVol: isRoot )
        
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
    func unmountDrives(mountBigmac: Bool, ejectAll: Bool) {
        let binary = "/usr/sbin/diskutil"
        let unmount = "unmount"
        let eject = "eject"
        let disks = ["Preboot","Recovery"]
        
        for disk in disks {
            _ = runCommandReturnString( binary: binary, arguments: [ unmount, disk ] ) ?? ""
        }
        
        if ejectAll {
            for disk in disks {
                _ = runCommandReturnString( binary: binary, arguments: [ eject, disk ] ) ?? ""
            }
        }
       
        
        if mountBigmac {
            _ = runCommandReturnString( binary: binary, arguments: [ "mount", "bigmac2" ] ) ?? ""
        }

    }
}


