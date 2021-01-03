//
//  postInstallAction.swift
//  bigmac2
//
//  Created by starplayrx on 1/1/21.
//

import Foundation

extension ViewController {
    
    @IBAction func patchDiskExec_action(_ sender: Any) {
        DispatchQueue.global(qos: .background).async { [self] in
            
            DispatchQueue.main.async { [self] in
                postInstallTask_label.stringValue = "Installing Selected Kexts..."
                postInstallDetails_label.stringValue = ""
                postInstallFuelGauge.doubleValue = 0
                postInstallProgressIndicator.doubleValue = 1
                postInstallSpinner.startAnimation(sender)
                postInstallSpinner.isHidden = false
            }
        
            patchBool()
            
            let driv = availablePatchDisks.title
            
            var isMatch = false
            var systemVolume : myVolumeInfo!
            var dataVolume : myVolumeInfo!
            
            systemVolume = getVolumeInfoByDisk(filterVolumeName: driv, disk: "")

            
            //MARK: Confirm we have a match
            ///This is a good practice and should be used when checking disks in the downloads areas
            if systemVolume == nil  {
                systemVolume = getVolumeInfoByDisk(filterVolumeName: "/", disk: "", isRoot: true)
                
                if systemVolume != nil {
                    if systemVolume.displayName == driv {
                        isMatch = true
                    }
                }
                
            } else if systemVolume.volumeName == driv {
                isMatch = true
            }
            
            //MARK: Decided what to do because things are not right
            if systemVolume == nil || !isMatch {
                return
            }
            

            let preboot = getDisk(substr: "Preboot", usingDiskorSlice: systemVolume.disk, isSlice: false) ?? systemVolume.disk + "s2"
            
            let dataSlice = getDisk(substr: "Data", usingDiskorSlice: systemVolume.disk, isSlice: false) ?? systemVolume.disk + "s1"
                
            let apfs = "/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util"
            var apfsUtil = "\(systemVolume.path)\(apfs)"


            if systemVolume.root {
                apfsUtil = apfs
            }
        
            let dataVolumeUUID = runCommandReturnString(binary: apfsUtil, arguments: [dataSlice]) ?? ""

            let dest = systemVolume.path
            let slek = "System/Library/Extensions"
            let uepi = "System/Library/UserEventPlugins"
            let lext = "Library/Extensions"
            let ulib = "usr/local/lib"
            
            _ = runCommandReturnString(binary: "/sbin/mount", arguments: ["-uw", systemVolume.path])
            
            
            if enableUSB {
                let kext = "IOHIDFamily.kext"
                let pass = installKext(dest: dest, kext: kext, fold: slek)
                print("enableUSB", "IOHIDFamily", pass)
            }
            
            if appleHDA {
                let kext = "AppleHDA.kext"
                let pass = installKext(dest: dest, kext: kext, fold: slek)
                print("appleHDA", "AppleHDA", pass)
            }
            
            if superDrive {
                let kext = "ioATAFamily.kext"
                let pass = installKext(dest: dest, kext: kext, fold: slek)
                print("superDrive", "ioATAFamily", pass)
            }
            
            if legacyWiFi {
                var kext = "IO80211Family.kext"
                var pass = installKext(dest: dest, kext: kext, fold: slek)
                print("legacyWiFi", kext, pass)
                
                kext = "corecapture.kext"
                pass = installKext(dest: dest, kext: kext, fold: slek)
                print("corecapture", kext, pass)
            }
            
            if teleTrap {
                let kext = "telemetrap.kext"
                var pass = installKext(dest: dest, kext: kext, fold: slek)
                print("teleTrap", kext, pass)
                
                let plug = "com.apple.telemetry.plugin"
                pass = installKext(dest: dest, kext: plug, fold: uepi)
                print("SSE4Telemetry", plug, pass)
            }
            
            if amdMouSSE {
                let kext = "AAAMouSSE.kext"
                let pass = installKext(dest: dest, kext: kext, fold: lext)
                print("amdMouSSE", kext, pass)
            }
            
            if hdmiAudio {
                let kext = "HDMIAudio.kext"
                let pass = installKext(dest: dest, kext: kext, fold: lext)
                print("hdmiAudio", kext, pass)
            }
            
            //SUVMMFaker
            if appStoreMacOS {
                let dlib = "SUVMMFaker.dylib"
                var pass = installKext(dest: dest, kext: dlib, fold: ulib)
                print("appStoreMacOS", dlib, pass)
                
                let plst = "com.apple.softwareupdated.plist"
                let dmns = "System/Library/LaunchDaemons"
                pass = installKext(dest: dest, kext: plst, fold: dmns)
                print("appStoreMacOS", plst, pass)
            }
            
            if disableBT2 {
                let fold = "System/Library/Extensions/IOUSBHostFamily.kext/Contents/PlugIns/AppleUSBHostMergeProperties.kext/Contents"
                let list = "Info.plist"
                let prfx = "usb"
                
                let pass = installKext(dest: dest, kext: list, fold: fold, prfx: prfx)
                print("disableBT2", prfx, list, pass)
            }
            
            DispatchQueue.main.async { [self] in
                postInstallProgressIndicator.doubleValue += 1
            }
            
            postInstallTask_label.stringValue = "Making disk bootable..."

            BootSystem(system: systemVolume, dataVolumeUUID: dataVolumeUUID, isVerbose: VerboseBoot, isSingleUser: singleUser, prebootVolume: preboot)
            
            var sysPath = systemVolume.path + "/"
            
            if systemVolume.root {
                sysPath = systemVolume.path
            }
            
            DispatchQueue.main.async { [self] in
                postInstallProgressIndicator.doubleValue += 1
            }
            
            
            //MARK Update Boot, System Caches
            if updateBootSysKCs.state == .on {
                postInstallTask_label.stringValue = "Updating Kernel Collections and Prelinked Kernel..."

                updateMac11onMac11SystemCache(destVolume: sysPath)
            }
            
            //** Let's kill the snapshots **//
            
            if deleteAPFSSnapshotsButton.state == .on {
                postInstallTask_label.stringValue = "Deleting Snapshots..."

                let plist = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["apfs", "listsnapshots", "-plist", systemVolume.diskSlice]) ?? ""
                
                
                //Delete Snapshotsw
                do {
                    
                    if  let plistData: Data = plist.data(using: .utf8) {
                        let decoder = PropertyListDecoder()
                        let snapshots = try decoder.decode(Snapshots.self, from: plistData).snapshots
                        
                        for s in snapshots {
                            
                            runIndeterminateProcess(binary: "/usr/sbin/diskutil", arguments: ["apfs", "deletesnapshot", "-xid", "\(s.snapshotXID)"], title: "Deleting Snapshot \(s.snapshotName)", sleepForHeadings: false)
                            
                            //runIndeterminateProcess(binary: "/usr/sbin/diskutil", arguments: ["apfs", "deletesnapshot", "-uuid", "\(s.snapshotUUID)"], title: "Deleting Snapshot \(s.snapshotName)")

                           // diskutil apfs deletesnapshot "$destVolume" -uuid $uuid
                        }
                    }
                 
                } catch {
                    // Handle error
                    print(error)
                }
            }
            
            if BlessVolume.state == .on {
                
                if let app = appFolder  {
                    let bless = app.path + "/bless"
                    var path = systemVolume.path + "/"
                    
                    if systemVolume.root {
                        path = systemVolume.path
                    }
                    
                    runIndeterminateProcess(binary: bless, arguments: ["--folder", "\(path)System/Library/CoreServices" , "--bootefi", "--label", systemVolume.displayName, "--setBoot"], title: "Blessing System Volume \(systemVolume.displayName)", sleepForHeadings: true)
                }
            }
            
            DispatchQueue.main.async { [self] in
                postInstallProgressIndicator.doubleValue += 1
                postInstallFuelGauge.doubleValue += 1
                postInstallFuelGauge.doubleValue = postInstallFuelGauge.maxValue
                postInstallProgressIndicator.doubleValue = postInstallProgressIndicator.maxValue
                postInstallSpinner.stopAnimation(sender)
                postInstallSpinner.isHidden = true
            }
        }
        
        
    }
}



