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
            
            
            let gotDisks = getVolumeInfo(includeHiddenVolumes: true, includeRootVol: true, includePrebootVol: true)
            
            let dataVol = gotDisks?.filter { $0.diskSlice == dataSlice }
            
            dataVolume = dataVol?.first
            
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
                let pass = installKext(dest: dest, kext: kext, fold: slek)
                print("teleTrap", kext, pass)
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
            
            if SSE4Telemetry {
                let plug = "com.apple.telemetry.plugin"
                let pass = installKext(dest: dest, kext: plug, fold: uepi)
                print("SSE4Telemetry", plug, pass)
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
            
            postInstallProgressIndicator.doubleValue += 1
        
            BootSystem(system: systemVolume, dataVolume: dataVolume, isVerbose: VerboseBoot, isSingleUser: singleUser, prebootVolume: preboot)
            
            var sysPath = systemVolume.path + "/"
            
            if systemVolume.root {
                sysPath = systemVolume.path
            }
            
            postInstallProgressIndicator.doubleValue += 1

            updateMac11onMac11SystemCache(destVolume: sysPath)
            
            DispatchQueue.main.async { [self] in
                postInstallFuelGauge.doubleValue = postInstallFuelGauge.maxValue
                postInstallProgressIndicator.doubleValue = postInstallProgressIndicator.maxValue
                postInstallSpinner.stopAnimation(sender)
                postInstallSpinner.isHidden = true


            }
        }
        
       
    }
}


/*
snapshots=$(diskutil apfs listsnapshots "$destVolume" | grep +-- | awk '{print $2}')
for uuid in $snapshots
do
    printf '📸 Attempting to delete snapshot => $uuid \n"
    n
    
    diskutil apfs deletesnapshot "$destVolume" -uuid $uuid
done
*/
