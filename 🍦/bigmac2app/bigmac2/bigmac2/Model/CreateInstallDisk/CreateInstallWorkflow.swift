//
//  CreateInstallWorkflow.swift
//  bigmac2
//
//  Created by starplayrx on 12/30/20.
//

import Foundation

extension ViewController {
    
    
    //MAIN WORKFLOW STARTS HERE
    
    
    //MARK: Install Disk Setup
    func disk(isBeta:Bool, diskInfo: myVolumeInfo, isVerbose: Bool, isSingleUser: Bool) {
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
            setupPreboot(diskInfo: diskInfo, bm2: bm2, rndStr: rndStr, isVerbose: isVerbose, isSingleUser: isSingleUser)
            
            print(bm2)
            
            installEmojiFont(bm2: bm2)
            
            incrementInstallGauge(resetGauge: false, incremment: true, setToFull: false)

            //MARK: Step 7
            bigSurInstallerAppXfer(rndStr: rndStr)
                        
            //MARK: Step 8 cleanup
            cleanup(bm2: bm2, rndStr: rndStr)
            
            unmountDrives(mountBigmac: true, ejectAll: false)
            
            //MARK: Finish
            incrementInstallGauge(resetGauge: false, incremment: false, setToFull: true)
            spinnerAnimation(start: false, hide: true)
        }
    }
}
