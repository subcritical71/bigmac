//
//  CreateInstallDisk.swift
//  bigmac2
//
//  Created by starplayrx on 12/21/20.
//

import Foundation

class CreateInstall : ViewController {
    
    func downloadPkg() {
        //Remove pre-existing file
        _ = runCommandReturnString(binary: "/bin/rm", arguments: ["-Rf","/tmp/InstallAssistant.pkg"]) //Future check if it's complete and has right checksum
        
        DispatchQueue.global(qos: .background).async {
            self.download(urlString: "https://starplayrx.com/downloads/bigmac/BaseSystem_offline.dmg")
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
    
    //MARK: Spinner Animation
    internal func spinnerAnimation (start: Bool, hide: Bool) {
        
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
    
    //MARK: Check for root user
    internal func checkForRootUser () -> Bool {
        rootMode || NSUserName() == "root" ? true : false
    }
    
    //MARK: Make Directory - To do use File Manager (For alot of these future tasks)
    internal func mkDir(bin: String = "/bin/mkdir", arg: String) -> String {
        let result = runCommandReturnString(binary: bin , arguments: [string]) ?? ""
        return result
    }
    
    //MARK: Mount diskimage and parse disk#s#
    internal func mountDiskImage(bin: String = "/usr/bin/hdiutil", arg: [String]) -> String {
        
        if var mountedDisk = runCommandReturnString(binary: bin , arguments: arg) {
            
            for _ in 1...3 {
                mountedDisk = mountedDisk.replacingOccurrences(of: "     ", with: " ")
                mountedDisk = mountedDisk.replacingOccurrences(of: "   ", with: " ")
                mountedDisk = mountedDisk.replacingOccurrences(of: "  ", with: " ")
            }
            
            let hdiArray1 = mountedDisk.components(separatedBy: "\n")
            var hdiArray2 = [[String]]()
            for var i in hdiArray1 {
                i = i.replacingOccurrences(of: " ", with: "")
                
                var subArray = i.components(separatedBy: "\t")
                
                if let _ = subArray.last?.isEmpty {
                    subArray = subArray.dropLast()
                }
                
                if !subArray.isEmpty {
                    hdiArray2.append(subArray)
                }
            }
            return mountedDisk
        }
        return ""
    }
    
    //MARK: Extract DMG from Zip file
    func extractDMGfromZip(bin: String = "/usr/bin/zip", arg: [String] ) -> String {
        let result = runCommandReturnString(binary: bin , arguments: arg) ?? ""
        return result
    }
    
    //MARK: Installer disk Root Mode Function (if not root mode, then uses NSAppleScript to make the call)
    func execViaRoot(isRootUser: Bool, binStr: String, argStr: String, dmgPath: String) -> String {
        
        if isRootUser {
            let result = runCommandReturnString(binary: "/usr/sbin/asr", arguments: ["\(argStr)"]) ?? ""
            return result
        } else {
            let installBigSurToApplication = "do shell script \"\(argStr)\" user name \"\(userName)\" password \"\(passWord)\" with administrator privileges"
            let result = performAppleScript(script: installBigSurToApplication)
            return result.text ?? ""
        }
    }
    
    
    //MARK: Install Disk Setup
    func disk(isBeta:Bool) {
        
        let tmp = "tmp"
        let sharedsupport = "SharedSupport"
        let bigmac2 = "bigmac2"
        let applications = "Applications"
        let basesystem = "BaseSystem"
        let appFolder = Bundle.main.resourceURL
        let dmgPath = "\(appFolder!.path)/\(bigmac2).dmg"
        
        var installBigSur = "Install macOS Big Sur.app"

        if isBeta {
            installBigSur = "Install macOS Big Sur Beta.app"
        }
        
        DispatchQueue.global(qos: .background).async { [self] in
            incrementInstallGauge(resetGauge: true, incremment: false, setToFull: false)

            //MARK: make temp dir SharedSupport
            _ = mkDir(arg: "/\(tmp)/\(sharedsupport)")
            
            //MARK: mount disk image inside temp SharedSupport
            let mountedDisk = mountDiskImage(arg: ["mount", "-mountPoint", "/\(tmp)/\(sharedsupport)", "/\(applications)/\(installBigSur)/Contents/\(sharedsupport)/\(sharedsupport).dmg", "-noverify", "-noautoopen", "-noautofsck", "-nobrowse"])
            print(mountedDisk) //MARK: to do parse the data out
            
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
            
            //MARK: Extract Base System from Zip file from Shared Support DMG
            _ = extractDMGfromZip(arg: ["/\(tmp)/\(sharedsupport)/*.zip AssetData/Restore/\(basesystem).dmg > /\(tmp)/\(bigmac2).dmg"])
  
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)

            //MARK: Exec ASR Via Root (uses NSAppleScript if under user mode)
            execViaRoot(isRootUser: rootMode, binStr: "/usr/sbin/asr", argStr: "-s \(dmgPath) -t \(installerVolume) -er -nov -nop", dmgPath: dmgPath)
           
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)

        }
        
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
        // createInstallSpinner.stopAnimation(sender)
        //}
        
    }
    
}
