//
//  Utilities.swift
//  bigmac2
//
//  Created by starplayrx on 1/1/21.
//

import Cocoa

// MARK: - System Info code
struct systemInfoCodable: Codable {
    let productVersion, productBuildVersion, productCopyright, productName: String
    let iOSSupportVersion, productUserVisibleVersion: String

    enum CodingKeys: String, CodingKey {
        case productVersion = "ProductVersion"
        case productBuildVersion = "ProductBuildVersion"
        case productCopyright = "ProductCopyright"
        case productName = "ProductName"
        case iOSSupportVersion
        case productUserVisibleVersion = "ProductUserVisibleVersion"
    }
}

extension ViewController {
    
    // MARK: Get System Info
    func getSystemInfo(drive:String) -> systemInfoCodable?   {
        
        let systemPath = "/Volumes/\(drive)/System/Library/CoreServices/SystemVersion.plist"
        //let systemURL = NSURL(string: systemPath)
        let systemURL = URL(fileURLWithPath: systemPath)
        
        var systemInfo : systemInfoCodable?
        do {
            let data = try Data(contentsOf: systemURL )
            let decoder = PropertyListDecoder()
            systemInfo = try decoder.decode(systemInfoCodable.self, from: data)
            
            return systemInfo
        } catch {
            // Handle error
            print(error)
        }
        
        return nil

    }
    
    func disableSetResXButtonsCheck() {
        if !fm.fileExists(atPath: setResX) {
            LowRes_720.isHidden = true
            HiRes_720.isHidden = true
            LowRes_1080.isHidden = true
            HiRes_1080.isHidden = true
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseBootArgs()
        disableSetResXButtonsCheck()
        bootedToBaseOS = checkForBaseOS()
        
        //MARK: Set Up and AI that knows what tab to do (checks for maybe an unpatch drive or 11.1 presence)
        if ( bootedToBaseOS) {
            tabViews.selectTabViewItem(preInstallTab)
            tabViews.drawsBackground = false
        }
        
        refreshPatchDisks()
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
                    print ( majorMinorVersion, i.displayName, i.root )
                    availablePatchDisks.addItem(withTitle: drive)
                }
            }
        }
    }
}
