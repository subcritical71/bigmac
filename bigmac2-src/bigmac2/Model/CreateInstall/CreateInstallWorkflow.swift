//
//  CreateInstallWorkflow.swift
//  bigmac2
//
//  Created by starplayrx on 12/30/20.
//

import Foundation

extension ViewController {
    
    //MAIN WORKFLOW STARTS HERE
    
    //MARK: Full Disk Workflow - Not for Customer Use as it is very backward compatible
    func disk2(isBeta:Bool, diskInfo: myVolumeInfo, isVerbose: Bool, isSingleUser: Bool, fullDisk: Bool) {
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
            unmountDrives(mountBigmac: false, ejectAll: true)
            
            //MARK: Step 1
            updateInstallerPkg()
            
            
            //MARK: Step 2
            reformatSelectedApfsDisk(diskInfo: diskInfo)
            
            //MARK: Step 3
            extractBaseSystem()
            
            sleep(1)
            
            //MARK: Step 4
            createDirectory(diskInfo: diskInfo, disk: "bm2tmp0", rndStr: rndStr)
            
            sleep(1)
            
            //MARK: Step 5
            installBaseSystem(diskInfo: diskInfo, baseSys: baseSys, bm2: bm2)
            
            
            sleep(1)
            
            //MARK: Step 6
            setupPreboot(diskInfo: diskInfo, bm2: bm2, rndStr: rndStr, isVerbose: isVerbose, isSingleUser: isSingleUser, slice: "s2")

            if fullDisk {
                
                //MARK: Step 6.5
                installEmojiFont(bm2: bm2)
                incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)

                //MARK: Step 7
                bigSurInstallerAppXfer(rndStr: rndStr)
    
            }
        
            //MARK: Step 8 cleanup
            cleanup(bm2: bm2, rndStr: rndStr)
            
            unmountDrives(mountBigmac: true, ejectAll: false)
            
            //MARK: Finish
            incrementInstallGauge(resetGauge: false, incremment: false, setToFull: true)
            spinnerAnimation(start: false, hide: true)
        }
    }
    
    
    
    func customerInstallDisk(isBeta:Bool, diskInfo: myVolumeInfo, isVerbose: Bool, isSingleUser: Bool, fullDisk: Bool) {
        DispatchQueue.global(qos: .background).async { [self] in
            incrementInstallGauge(resetGauge: true, incremment: true, setToFull: false, cylon: true, title: "Firing up the install disk process...")
            
            //MARK: Set vars and local constants
            if isBeta {
                installBigSur = "Install macOS Big Sur Beta.app" //Not currently implemented
            }
            
            let rndStr = ""
            let baseSys = "macOS Base System"
            let bm2 = bigmac2
            
            //MARK: Step 1a
     
            spinnerAnimation(start: true, hide: false)
            
            //MARK: Step 2a
            unmountDrives(mountBigmac: false, ejectAll: true)

            //MARK: Step 2a
            incrementInstallGauge(resetGauge: true, incremment: true, setToFull: false, cylon: true, title: "Updating Installer Package...")
            updateInstallerPkg()

            //MARK: Step 3a
            incrementInstallGauge(resetGauge: true, incremment: true, setToFull: false, cylon: true, title: "Reformatting the \(diskInfo.displayName) AFPS volume...")
            reformatSelectedApfsDisk(diskInfo: diskInfo)
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false, cylon: true)

            //MARK: Step 4a
            installBaseSystemII(diskInfo: diskInfo, baseSys: baseSys, bm2: bm2)
            
            let prebootDiskSlice = getDisk(substr: "Preboot", usingDiskorSlice: diskInfo.disk, isSlice: false) ?? diskInfo.disk + "s2"
            
            //Get Preboot Ready
            _ = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["mount", diskInfo.diskSlice])

            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false, cylon: true, title: "Making the bigmac2 installer disk bootable...")

            //MARK: Update systemVolume volume because UUIDs have changed
            if let systemVolume = getVolumeInfoByDisk(filterVolumeName: diskInfo.volumeName, disk: diskInfo.disk, isRoot: diskInfo.root) {
                
                _ = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["mount", systemVolume.diskSlice])

                BootSystem(system: systemVolume, dataVolumeUUID: systemVolume.uuid, isVerbose: isBaseVerbose, isSingleUser: isBaseSingleUser, prebootVolume: prebootDiskSlice, isBaseSystem: true)
            } else {
                print("Bootable System Failure.")
            }
                        
            //MARK: Step 5a
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false, title: "Installing the Apple Emoji Font...")
            installEmojiFont(bm2: bm2)
        
            //MARK: Step 6a
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false, title: "Installing the Big Mac 2 App...")
            installTheApp(bigmac2: diskInfo)
            
            if fullDisk {
                incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false, cylon: false, title: "Installing the macOS 11 App...")
                
                //MARK: Step 7a
                bigSurInstallerAppXfer(rndStr: rndStr)
                incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)
            }
            
            //MARK: Step 8a
            cleanup(bm2: bm2, rndStr: rndStr)
            unmountDrives(mountBigmac: true, ejectAll: false)
            
            //MARK: Finish
            incrementInstallGauge(resetGauge: false, incremment: false, setToFull: true, title: "bigmac2 Boot Disk installation is complete!")
            spinnerAnimation(start: false, hide: true)
        }
    }
    
    

}
