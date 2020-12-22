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
    internal func incrementInstallGauge() {
        DispatchQueue.main.async { [self] in
            installerFuelGauge.doubleValue += 1
        }
    }
    
    
    //MARK: Install Disk Setup
    func disk() {
        
        //To Do add check
        
        installerFuelGauge.doubleValue = 0

        //export SUDO_ASKPASS=/usr/local/bin/ssh-askpass
       // let howmeDirURL = URL(fileURLWithPath: NSHomeDirectory())
        
        var runner = true
        
        if !rootMode && (userName.isEmpty || passWord.isEmpty) {
            runner = false
        } else {
            createInstallSpinner.startAnimation(self)
        }
        
        if ( runner ) {
            
           

            DispatchQueue.global(qos: .background).async {

                _ = runCommandReturnString(binary: "/bin/mkdir" , arguments: ["/tmp/sharedsupport"])

                if var hdiutilReturn = runCommandReturnString(binary: "/usr/bin/hdiutil" , arguments: ["mount", "-mountPoint", "/tmp/sharedsupport", "/Applications/Install macOS Big Sur.app/Contents/SharedSupport/SharedSupport.dmg", "-noverify", "-noautoopen", "-noautofsck", "-nobrowse"]) {
                    
                    for _ in 1...3 {
                        hdiutilReturn = hdiutilReturn.replacingOccurrences(of: "     ", with: " ")
                        hdiutilReturn = hdiutilReturn.replacingOccurrences(of: "   ", with: " ")
                        hdiutilReturn = hdiutilReturn.replacingOccurrences(of: "  ", with: " ")
                    }
                    
                    
                    let hdiArray1 = hdiutilReturn.components(separatedBy: "\n")
                    var hdiArray2 = [[String]]()
                    for var i in hdiArray1 {
                        i = i.replacingOccurrences(of: " ", with: "")
                        
                        var subArray = i.components(separatedBy: "\t")
                     //
                        if let _ = subArray.last?.isEmpty {
                            subArray = subArray.dropLast()
                        }
                        
                        if !subArray.isEmpty {
                            hdiArray2.append(subArray)
                        }
                    
                    }
                    
                    print(hdiArray2)
                    DispatchQueue.main.async { [self] in
                        installerFuelGauge.doubleValue += 1
                    }
                }

                _ = runCommandReturnString(binary: "/usr/bin/zip" , arguments: ["mkdir /tmp/sharedsupport/*.zip AssetData/Restore/BaseSystem.dmg > /tmp/bigmac2.dmg"])
               
                DispatchQueue.main.async { [self] in
                    installerFuelGauge.doubleValue += 1
                }
            }
            
            DispatchQueue.global(qos: .background).async { [self] in

                let appFolder = Bundle.main.resourceURL
                let dmgPath = "\(appFolder!.path)/bigmac2.dmg"
            
                if rootMode {
                    _ = runCommandReturnString(binary: "/usr/sbin/asr", arguments: ["asr -s \(dmgPath) -t \(installerVolume) -er -nov -nop"]) //do to ask for which volume
                    
                    DispatchQueue.main.async { [self] in
                        installerFuelGauge.doubleValue += 1
                    }
                } else {
                    let installBigSurToApplication = "do shell script \"sudo asr -s \(dmgPath) -t \(installerVolume) -er -nov -nop\" user name \"\(userName)\" password \"\(passWord)\" with administrator privileges"
                    _ = performAppleScript(script: installBigSurToApplication)
                    
                    DispatchQueue.main.async { [self] in
                        installerFuelGauge.doubleValue += 1
                    }
                }
               
            }
        }
    
        //DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
           // createInstallSpinner.stopAnimation(sender)
        //}

    }
    
}
