//
//  ViewController.swift
//  bigmac2
//
//  Created by starplayrx on 12/18/20.
//

import AppKit
import Foundation




class ViewController: NSViewController, URLSessionDelegate {
    
    //get Home Folder
    let tempFolder = "/tmp"
    var downloadProgress = Float(-1.0)
    var sourcePath: String?
    var targetPath: String?
    
    let fm = FileManager.default
    let tmp = "tmp"
    let sharedsupport = "SharedSupport"
    let bigmac2 = "bigmac2"
    let tempDiskImage = "bm2tmp0"
    
    let applications = "Applications"
    let basesystem = "BaseSystem"
    let appFolder = Bundle.main.resourceURL
    let haxDylib = Bundle.main.resourceURL!.path + "/HaxDoNotSealNoAPFSROMCheck.dylib"
    let tempSystem = Bundle.main.resourceURL!.path + "/bm2tmp0.dmg"
    let macSoftwareUpdate = "com_apple_MobileAsset_MacSoftwareUpdate"
    var installBigSur = "Install macOS Big Sur.app"
    let wildZip = "*.zip"
    let restoreBaseSystem = "AssetData/Restore/BaseSystem.dmg"
    
    var installerVolume = "/Volumes/bigmac2"
    var timer: Timer?
    let shared = "Shared/" //copy to shared directory

    var getEraseDisk : ()? = nil
    var getCreateDisk : ()? = nil

    //MARK: Downloads Tab
    @IBOutlet weak var mediaLabel: NSTextField!
    @IBOutlet weak var progressBarDownload: NSProgressIndicator!
    @IBOutlet weak var buildLabel: NSTextField!
    @IBOutlet weak var gbLabel: NSTextField!
    @IBOutlet weak var percentageLabel: NSTextField!
    @IBOutlet weak var createInstallSpinner: NSProgressIndicator!
    @IBOutlet weak var installerFuelGauge: NSLevelIndicator!
    @IBOutlet weak var sharedSupportProgressBar: NSProgressIndicator!
    @IBOutlet weak var sharedSupportPercentage: NSTextField!
    @IBOutlet weak var sharedSupportGbLabel: NSTextField!
    
    //MARK: Preinstall Tab -- Outlets
    @IBOutlet weak var bootArgsField: NSTextField!
    @IBOutlet weak var DisableLibraryValidation: NSButton!
    @IBOutlet weak var hax3DoNotSealAPFS: NSButton!
    @IBOutlet weak var DisableSIP: NSButton!
    @IBOutlet weak var DisableAuthRoot: NSButton!
    @IBOutlet weak var LaunchInstaller: NSButton!
    
   
    //MARK:
}



extension ViewController {
   
    @IBAction func LaunchInstallerAction(_ sender: Any) {
        
        let bootArgs = bootArgsField.stringValue
       /// let disableLibValidation = (DisableLibraryValidation.state == NSControl.StateValue.on) ?
        
        let libVal = DisableLibraryValidation.state == .on
        let hax3 = hax3DoNotSealAPFS.state == .on
        let SIP = DisableSIP.state == .on
        let AR = DisableAuthRoot.state == .on
        
        ///
        ///
        func preInstallRunner(libVal: Bool, hax3: Bool, SIP: Bool, AR: Bool) {
            
            
            if libVal {
                _ = runCommandReturnString(binary: "/usr/bin/defaults" , arguments: ["write", "/Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation", "-bool", "true"]) ?? ""
            }
            
            
            ///bin/launchctl
            
            // launchctl  DYLD_INSERT_LIBRARIES "$asentientbot$barrykn"
            if libVal {
                _ = runCommandReturnString(binary: "/bin/launchctl" , arguments: ["setenv", "DYLD_INSERT_LIBRARIES", haxDylib]) ?? ""
            }
           

            
        }
        
        
        
        preInstallRunner(libVal: libVal, hax3: hax3, SIP: SIP, AR: AR)
        


    }
    
    
    
}



