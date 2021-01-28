//
//  CreateInstallWorkflow.swift
//  bigmac2
//
//  Created by starplayrx on 12/30/20.
//

import Foundation

extension ViewController {
    
    //MAIN WORKFLOW STARTS HERE
    func installIsoBootDisk(diskInfo: myVolumeInfo, isVerbose: Bool, isSingleUser: Bool) {
        
        DispatchQueue.global(qos: .background).async { [self] in
            spinnerAnimation(start: true, hide: false)
            incrementInstallGauge(resetGauge: true, incremment: true, setToFull: false, cylon: true, title: "Firing up the install disk process...")
          
            let baseSys = "macOS Base System"
            let bm2 = bigmac2
            let dmg = bigmacDMG
        
            _ = updateInstallerPkg(installBigSurApp: installBigSur)
            
            //MARK: Check the Big Sur app is ready
            guard let pass = installBigSurCheckPoint(installBigSurApp: installBigSur), pass == true else {
                return
            }
       
            installDMGviaASR(diskInfo: diskInfo, baseSys: baseSys, bm2: bm2, dmg: dmg)
            
            let prebootDiskSlice = getDisk(substr: "Preboot", usingDiskorSlice: diskInfo.disk, isSlice: false) ?? diskInfo.disk + "s2"
            let diskInfo = getVolumeInfoByDisk(filterVolumeName: bigmac2Str, disk: diskInfo.disk) ?? diskInfo

            installBigMacIIApp(bigmac2: diskInfo)

            //MARK: Update systemVolume volume because UUIDs have changed
            baseBootPlister(diskInfo: diskInfo, isVerbose: isBaseVerbose, isSingleUser: isSingleUser, prebootVolume: prebootDiskSlice, isBaseSystem: true)
                 
            installEmojiFont(diskInfo: diskInfo)
            bigSurInstallerAppXfer(isBeta: false, BootVolume: diskInfo)
            createDiskEnded(completed: true)
  
        }
    }
    
    
    //MAIN WORKFLOW STARTS HERE
    func installDmgBootDisk(diskInfo: myVolumeInfo, isVerbose: Bool, isSingleUser: Bool) {
        
        DispatchQueue.global(qos: .background).async { [self] in
            spinnerAnimation(start: true, hide: false)
            incrementInstallGauge(resetGauge: true, incremment: true, setToFull: false, cylon: true, title: "Firing up the install disk process...")
            
            let baseSys = "macOS Base System"
            let bm2 = bigmac2
            let dmg = bigmacDMG
        
            installDMGviaASR(diskInfo: diskInfo, baseSys: baseSys, bm2: bm2, dmg: dmg)
            
            let prebootDiskSlice = getDisk(substr: "Preboot", usingDiskorSlice: diskInfo.disk, isSlice: false) ?? diskInfo.disk + "s2"

            let diskInfo = getVolumeInfoByDisk(filterVolumeName: bigmac2Str, disk: diskInfo.disk) ?? diskInfo

            installBigMacIIApp(bigmac2: diskInfo)

            //MARK: Update systemVolume volume because UUIDs have changed
            baseBootPlister(diskInfo: diskInfo, isVerbose: isBaseVerbose, isSingleUser: isSingleUser, prebootVolume: prebootDiskSlice, isBaseSystem: true)
                 
            installEmojiFont(diskInfo: diskInfo)
            bigSurInstallerDmgXfer(isBeta: false, BootVolume: diskInfo)
            createDiskEnded(completed: true)
        }
    }
    
    
    //MAIN WORKFLOW STARTS HERE
    func installMacOSdiskImageX(diskInfo: myVolumeInfo, isVerbose: Bool, isSingleUser: Bool) {
        DispatchQueue.global(qos: .background).async { [self] in
            spinnerAnimation(start: true, hide: false)
            incrementInstallGauge(resetGauge: true, incremment: true, setToFull: false, cylon: true, title: "Starting macOS install DMG process...")
            
            let baseSys = "macOS DMG Installation"
            let bm2 = macOS
        
            //MARK: Step 2
            reformatSelectedApfsDisk(diskInfo: diskInfo)

            //MARK: Step 3
            
            
            installDMGviaASR(diskInfo: diskInfo, baseSys: baseSys, bm2: bm2, dmg: globalDownloadMacOSdmgName)
            
            let prebootDiskSlice = getDisk(substr: "Preboot", usingDiskorSlice: diskInfo.disk, isSlice: false) ?? diskInfo.disk + "s2"

            let diskInfo = getVolumeInfoByDisk(filterVolumeName: bigmac2Str, disk: diskInfo.disk) ?? diskInfo

            //MARK: Update systemVolume volume because UUIDs have changed
            baseBootPlister(diskInfo: diskInfo, isVerbose: isBaseVerbose, isSingleUser: isSingleUser, prebootVolume: prebootDiskSlice, isBaseSystem: true)

            createDiskEnded(completed: true)
        }
    }
}


//MARK: Full Disk Workflow - Not for Customer Use as it is very backward compatible
/* func disk2(isBeta:Bool, diskInfo: myVolumeInfo, isVerbose: Bool, isSingleUser: Bool, fullDisk: Bool) {
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
        createDirectory(diskInfo: diskInfo, disk: "wtmp0", rndStr: rndStr)
        
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
}*/
