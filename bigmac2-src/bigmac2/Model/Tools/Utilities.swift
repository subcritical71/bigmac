//
//  Utilities.swift
//  bigmac2
//
//  Created by starplayrx on 1/1/21.
//

import Cocoa


extension ViewController {
    

    //MARK: Mount Big Data
    func mountBigData() {
        
        if let appFolder = Bundle.main.resourceURL?.path {
            
            let dir = "/\(tmp)/\(bigdata)"
            
            if checkIfFileExists(path: dir) {
                _ = mkDir(arg: "/\(tmp)/\(bigdata)")
            }
                    
            //MARK: mount disk image inside temp SharedSupport
            _ = mountDiskImage(arg: ["mount", "-mountPoint", "/\(dir)", "\(appFolder)/\(bigdata).dmg", "-noverify", "-noautoopen", "-noautofsck", "-nobrowse"])
        }
    }
    
    //MARK: Unmount Big Data
    func unmountBigData() {
        
        let dir = "/\(tmp)/\(bigdata)"
        
        _ = mountDiskImage(arg: ["eject", "/\(dir)"])
        _ = mountDiskImage(arg: ["eject", "/Volumes/\(bigdata)"])
        
        if checkIfFileExists(path: dir) {
            _ = rmDir(arg: "/\(tmp)/\(bigdata)")
        }
        
    }
    
    // MARK: Get System Info
    func getSystemInfo(drive:String) -> systemInfoCodable?   {
        
        let path = "/Volumes/\(drive)/System/Library/CoreServices/SystemVersion.plist"
        if checkIfFileExists(path: path) {
            let systemPath = path
            //let systemURL = NSURL(string: systemPath)
            let systemURL = URL(fileURLWithPath: systemPath)
            var systemInfo : systemInfoCodable?
            do {
                let data = try Data(contentsOf: systemURL )
                let decoder = PropertyListDecoder()
                systemInfo = try decoder.decode(systemInfoCodable.self, from: data)
                
                return systemInfo
            } catch {
                print(error)
            }
        }
    
        return nil
    }
    
    func disableSetResXButtonsCheck() {
        if !fm.fileExists(atPath: setResX) {
            LowRes_720.isEnabled = false
            HiRes_720.isEnabled = false
            LowRes_1080.isEnabled = false
            HiRes_1080.isEnabled = false
        }
    }
    
    //MARK: Move to Utilities
    func checkIfFileExists(path: String) -> Bool {
        if fm.fileExists(atPath: path) {
            return true
        } else {
            return false
        }
    }
    
    func checkForBaseOS() -> Bool {
        if fm.fileExists(atPath: baseOS) {
            return true
        } else {
            return false
        }
    }
    
    func refreshPatchDisks() {
        if let getDisks = getVolumeInfo(includeHiddenVolumes: false, includeRootVol: true) {
            
            availablePatchDisks.removeAllItems()
            
            for i in getDisks {
                var drive = ""
                if i.root {
                    drive = i.displayName
                } else {
                    drive = i.volumeName
                }
                
                //MARK: bigmac2 is omitted, we don't want users trying to patch bigmac2
                if let systemInfo = getSystemInfo(drive: drive), i.displayName != bigmac2Str {
                    let majorMinorVersion = systemInfo.productUserVisibleVersion.components(separatedBy: ".")
                   // print ( majorMinorVersion, i.displayName, i.root )
                    
                    if majorMinorVersion.first == "11" {
                        availablePatchDisks.addItem(withTitle: drive)
                    }
                }
            }
        }
    }
    

    //MARK: This a better preboot routine
    func getDisk(substr: String, usingDiskorSlice: String, isSlice: Bool) -> String? {
        
        let pb = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["list", usingDiskorSlice]) ?? ""
        let pbArray = pb.components(separatedBy: "\n")
        
        for i in pbArray {
            if i.contains(substr) {
                if isSlice {
                    let prebootVolume = String(i.suffix(usingDiskorSlice.count))
                    return prebootVolume
                } else {
                    let prebootVolume = String(i.suffix(usingDiskorSlice.count + 2))
                    return prebootVolume
                }
            }
        }
        
        return nil
        
    }
    

}
