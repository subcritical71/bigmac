//
//  PostInstallWorkflow.swift
//  bigmac2
//
//  Created by starplayrx on 1/3/21.
//

import Foundation

extension ViewController {
    
    func indicatorBump(taskMsg: String = "", detailMsg: String = "", updateProgBar: Bool = false) {
        DispatchQueue.main.async { [self] in
            
            let taskLabel = postInstallTask_label.stringValue
            
            if updateProgBar {
                postInstallProgressIndicator.doubleValue += 1
            }
            if !taskLabel.contains(taskMsg) {
                postInstallFuelGauge.doubleValue += 1
            }
            
            if !taskMsg.isEmpty {
                postInstallTask_label.stringValue = taskMsg
                postInstallDetails_label.stringValue = detailMsg
            }
            
        }
        
        if !taskMsg.isEmpty {
            sleep(1) //apply time to read the update
        }
    }
    
    func PostInstall() {
        indicatorBump(updateProgBar: true)

        var isMatch = false
        var systemVolume : myVolumeInfo!
                    
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
            
        var apfsUtil = "\(systemVolume.path)\(apfs)"

        if systemVolume.root {
            apfsUtil = apfs
        }

        let dataVolumeUUID = runCommandReturnString(binary: apfsUtil, arguments: ["-k", dataSlice]) ?? ""

        let dest = systemVolume.path
        let slek = "System/Library/Extensions"
        let uepi = "System/Library/UserEventPlugins"
        let lext = "Library/Extensions"
        let ulib = "usr/local/lib"
        
        _ = runCommandReturnString(binary: "/sbin/mount", arguments: ["-uw", systemVolume.path])
        
        if enableUSB {
            let kext = "IOHIDFamily.kext"
            let pass = installKext(dest: dest, kext: kext, fold: slek, ttle: enableUSBtl)
            print("enableUSB", "IOHIDFamily", pass)
        }
        
        if appleHDA {
            let kext = "AppleHDA.kext"
            let pass = installKext(dest: dest, kext: kext, fold: slek, ttle: appleHDAtl)
            print("appleHDA", "AppleHDA", pass)
        }
        
        if superDrive {
            let kext = "ioATAFamily.kext"
            let pass = installKext(dest: dest, kext: kext, fold: slek, ttle: superDrivetl)
            print("superDrive", "ioATAFamily", pass)
        }
        
        indicatorBump(updateProgBar: true)

        if legacyWiFi {
            var kext = "IO80211Family.kext"
            var pass = installKext(dest: dest, kext: kext, fold: slek, ttle: legacyWiFitl)
            print("legacyWiFi", kext, pass)
            
            kext = "corecapture.kext"
            pass = installKext(dest: dest, kext: kext, fold: slek, ttle: legacyWiFitl)
            print("corecapture", kext, pass)
        }
        
        if teleTrap {
            let kext = "telemetrap.kext"
            var pass = installKext(dest: dest, kext: kext, fold: slek, ttle: teleTraptl)
            print("teleTrap", kext, pass)
            
            let plug = "com.apple.telemetry.plugin"
            pass = installKext(dest: dest, kext: plug, fold: uepi, ttle: teleTraptl)
            print("SSE4Telemetry", plug, pass)
        }
        
        if amdMouSSE {
            let kext = "AAAMouSSE.kext"
            let pass = installKext(dest: dest, kext: kext, fold: lext, ttle: amdMouSSEtl)
            print("amdMouSSE", kext, pass)
        }
        
        indicatorBump(updateProgBar: true)

        if hdmiAudio {
            let kext = "HDMIAudio.kext"
            let pass = installKext(dest: dest, kext: kext, fold: lext, ttle: hdmiAudiotl)
            print("hdmiAudio", kext, pass)
        }
        
        //SUVMMFaker
        if appStoreMacOS {
            let dlib = "SUVMMFaker.dylib"
            var pass = installKext(dest: dest, kext: dlib, fold: ulib, ttle: appStoreMacOStl)
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
            
            let pass = installKext(dest: dest, kext: list, fold: fold, prfx: prfx, ttle: disableBT2tl)
            print("disableBT2", prfx, list, pass)
        }
        
        indicatorBump(updateProgBar: true)

        BootSystem(system: systemVolume, dataVolumeUUID: dataVolumeUUID, isVerbose: VerboseBoot, isSingleUser: singleUser, prebootVolume: preboot)
        
        indicatorBump(updateProgBar: true)

        var sysPath = systemVolume.path + "/"
        
        if systemVolume.root {
            sysPath = systemVolume.path
        }
    
        //MARK Update Boot, System Caches
        if installKCs {
            indicatorBump(taskMsg: "Updating Kernel Collections and Prelinked Kernel...")
            updateMac11onMac11SystemCache(destVolume: sysPath)
        }
        
        indicatorBump(updateProgBar: true)

        //MARK: Delete Snapshots
        if deleteSnaphots {
            
            indicatorBump()

            let plist = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["apfs", "listsnapshots", "-plist", systemVolume.diskSlice]) ?? ""
                
            //MARK: Delete Snapshots
            do {
                
                if  let plistData: Data = plist.data(using: .utf8) {
                    let decoder = PropertyListDecoder()
                    let snapshots = try decoder.decode(Snapshots.self, from: plistData).snapshots
                    
                    for s in snapshots {
                        
                        runIndeterminateProcess(binary: "/usr/sbin/diskutil", arguments: ["apfs", "deletesnapshot", "-xid", "\(s.snapshotXID)"], title: "Deleting Snapshot \(s.snapshotName)", sleepForHeadings: false)
                    
                    }
                    
                    indicatorBump()

                } else {
                    indicatorBump(taskMsg: "No Snapshots found")
                }
             
            } catch {
                // Handle error
                print(error)
            }
        }
        
        indicatorBump(updateProgBar: true)
        
        if blessSystem {
            
            if let app = appFolder  {
                let bless = app.path + "/bless"
                var path = systemVolume.path + "/"
                
                if systemVolume.root {
                    path = systemVolume.path
                }
                
                runIndeterminateProcess(binary: bless, arguments: ["--folder", "\(path)System/Library/CoreServices" , "--bootefi", "--label", systemVolume.displayName, "--setBoot"], title: "Blessing System Volume \(systemVolume.displayName)", sleepForHeadings: true)
            }
        }
        
        indicatorBump(updateProgBar: true)

    }
}
