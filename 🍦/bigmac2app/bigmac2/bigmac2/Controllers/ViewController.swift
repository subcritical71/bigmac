//
//  ViewController.swift
//  bigmac2
//
//  Created by starplayrx on 12/18/20.
//

import Cocoa

class ViewController: NSViewController, URLSessionDelegate  {
    
    let setResX = "/Applications/RDM.app/Contents/MacOS/SetResX"
    let baseOS = "/Install macOS Big Sur.app/Contents/MacOS/InstallAssistant"
   
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
    let hax = Bundle.main.resourceURL!.path + "/hax3"

    let tempSystem = Bundle.main.resourceURL!.path + "/bm2tmp0.dmg"
    let macSoftwareUpdate = "com_apple_MobileAsset_MacSoftwareUpdate"
    var installBigSur = "Install macOS Big Sur.app"
    let wildZip = "*.zip"
    let restoreBaseSystem = "AssetData/Restore/BaseSystem.dmg"
    
    var installerVolume = "/Volumes/bigmac2"
    var timer: Timer?
    let shared = "Shared/" //copy to shared directory

    //MARK: Downloads Tab
    @IBOutlet weak var mediaLabel: NSTextField!
    @IBOutlet weak var progressBarDownload: NSProgressIndicator!
    @IBOutlet weak var buildLabel: NSTextField!
    @IBOutlet weak var gbLabel: NSTextField!
    @IBOutlet weak var percentageLabel: NSTextField!
    @IBOutlet weak var createInstallSpinner: NSProgressIndicator!
    @IBOutlet weak var installerFuelGauge: NSLevelIndicator!
    @IBOutlet weak var sharedSupportProgressBar: NSProgressIndicator!
    @IBOutlet weak var downloadLabel: NSTextField!

    @IBOutlet weak var sharedSupportPercentage: NSTextField!
    @IBOutlet weak var sharedSupportGbLabel: NSTextField!
    @IBOutlet weak var singleUserCheckbox: NSButton!
    @IBOutlet weak var verboseUserCheckbox: NSButton!
    
    //MARK: Preinstall Tab -- Outlets
    @IBOutlet weak var bootArgsField: NSTextField!
    @IBOutlet weak var DisableLibraryValidation: NSButton!
    @IBOutlet weak var DisableSIP: NSButton!
    @IBOutlet weak var DisableAuthRoot: NSButton!
    @IBOutlet weak var preInstallSpinner: NSProgressIndicator!

    //MARK: Tab Views
    @IBOutlet weak var tabViews: NSTabView!
    @IBOutlet weak var downloadsTab: NSTabViewItem!
    @IBOutlet weak var preInstallTab: NSTabViewItem!
    @IBOutlet weak var postInstallTab: NSTabViewItem!
    @IBOutlet weak var cloneToolTab: NSTabViewItem!
    
    //MARK: Screen Res Switching
    @IBOutlet weak var HiRes_1080: NSButton!
    @IBOutlet weak var LowRes_1080: NSButton!
    @IBOutlet weak var HiRes_720: NSButton!
    @IBOutlet weak var LowRes_720: NSButton!
    
    //MARK: Postinstall Tab
    @IBOutlet weak var enableUSB_btn: NSButton!
    @IBOutlet weak var disableBT2_btn: NSButton!
    @IBOutlet weak var amdMouSSE_btn: NSButton!
    @IBOutlet weak var teleTrap_btn: NSButton!
    @IBOutlet weak var SSE4Telemetry_btn: NSButton!
    @IBOutlet weak var VerboseBoot_btn: NSButton!
    @IBOutlet weak var superDrive_btn: NSButton!
    @IBOutlet weak var appleHDA_btn: NSButton!
    @IBOutlet weak var hdmiAudio_btn: NSButton!
    @IBOutlet weak var appStoreMacOS_btn: NSButton!
    @IBOutlet weak var legacyWiFi_btn: NSButton!
    @IBOutlet weak var singleUser_btn: NSButton!
    @IBOutlet weak var postInstallFuelGauge: NSLevelIndicator!
    @IBOutlet weak var postInstallProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var postInstallRunningIndicator: NSProgressIndicator!
    @IBOutlet weak var availablePatchDisks: NSPopUpButton!
    @IBOutlet weak var patchDiskExecution_btn: NSButton!
    
    func patchBool() {
        let enableUSB : Bool
        let disableBT2 : Bool
        let amdMouSSE : Bool
        let teleTrap : Bool
        let SSE4Telemetry : Bool
        let VerboseBoot : Bool
        let superDrive : Bool
        let appleHDA : Bool
        let hdmiAudio : Bool
        let appStoreMacOS : Bool
        let legacyWiFi : Bool
        let singleUser : Bool
  
        enableUSB       ? (enableUSB_btn.state == .on)      : (enableUSB_btn.state == .off)
        disableBT2      ? (disableBT2_btn.state == .on)     : (disableBT2_btn.state == .off)
        amdMouSSE       ? (amdMouSSE_btn.state == .on)      : (amdMouSSE_btn.state == .off)
        teleTrap        ? (teleTrap_btn.state == .on)       : (teleTrap_btn.state == .off)
        SSE4Telemetry   ? (SSE4Telemetry_btn.state == .on)  : (SSE4Telemetry_btn.state == .off)
        VerboseBoot     ? (VerboseBoot_btn.state == .on)    : (VerboseBoot_btn.state == .off)
        superDrive      ? (superDrive_btn.state == .on)     : (superDrive_btn.state == .off)
        appleHDA        ? (appleHDA_btn.state == .on)       : (appleHDA_btn.state == .off)
        hdmiAudio       ? (hdmiAudio_btn.state == .on)      : (hdmiAudio_btn.state == .off)
        appStoreMacOS   ? (appStoreMacOS_btn.state == .on)  : (appStoreMacOS_btn.state == .off)
        legacyWiFi      ? (legacyWiFi_btn.state == .on)     : (legacyWiFi_btn.state == .off)
        
    }s
    
    
    @IBAction func patchDiskExec_action(_ sender: Any) {
        
    }

 
}








//No need for this yet
class TabView : NSTabView {
    override func awakeFromNib() {
        
    }
}
