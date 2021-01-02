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
    
    var enableUSB = Bool()
    var disableBT2 = Bool()
    var amdMouSSE = Bool()
    var teleTrap = Bool()
    var SSE4Telemetry = Bool()
    var VerboseBoot = Bool()
    var superDrive = Bool()
    var appStoreMacOS = Bool()
    var appleHDA = Bool()
    var hdmiAudio = Bool()
    var singleUser = Bool()
    var legacyWiFi = Bool()

    
    func patchBool() {
        enableUSB       = (enableUSB_btn.state == .on)
        disableBT2      = (disableBT2_btn.state == .on)
        amdMouSSE       = (amdMouSSE_btn.state == .on)
        teleTrap        = (teleTrap_btn.state == .on)
        SSE4Telemetry   = (SSE4Telemetry_btn.state == .on)
        VerboseBoot     = (VerboseBoot_btn.state == .on)
        superDrive      = (superDrive_btn.state == .on)
        appleHDA        = (appleHDA_btn.state == .on)
        hdmiAudio       = (hdmiAudio_btn.state == .on)
        appStoreMacOS   = (appStoreMacOS_btn.state == .on)
        singleUser      = (singleUser_btn.state == .on)
        legacyWiFi      = (legacyWiFi_btn.state == .on)
    }
    
    
    func installKext(dest: String, kext: String, fold: String, sour: String = "") -> Bool {
        var strg = ""
        let fail = "Do not pass"
        var pass = false
        let copy = "Copying"
        
        if let source = Bundle.main.resourceURL?.path {
            let destiny = "\(dest)/\(fold)/\(kext)"
            let mdir = "\(dest)/\(fold)/"
            print("")
            //MARK: To do add check if directory exists
            _ = runCommandReturnString(binary: "/bin/mkdir", arguments: [mdir])
            
            //MARK: Sour is used as a special prefix for the source file incase the name is different.
            strg = runCommandReturnString(binary: "/usr/bin/ditto", arguments: ["-v", "\(sour)\(source)/\(kext)", destiny]) ?? fail
            _ = runCommandReturnString(binary: "/usr/sbin/chown", arguments: ["-R", "0:0", destiny])
            _ = runCommandReturnString(binary: "/bin/chmod", arguments: ["-R", "755", destiny])
            _ = runCommandReturnString(binary: "/usr/bin/touch", arguments: [destiny])
        }
    
        strg = strg.replacingOccurrences(of: "\n", with: "")
        strg = strg.replacingOccurrences(of: "\r", with: "")
        strg = strg.replacingOccurrences(of: " ", with: "")

        if strg.hasPrefix(copy) && strg.hasSuffix(kext)  {
            pass = !pass
        }
        
        return pass
    }
    
    @IBAction func patchDiskExec_action(_ sender: Any) {
        let driv = availablePatchDisks.title
        let dest = "/Volumes/\(driv)"
        let slek = "System/Library/Extensions"
        let uepi = "System/Library/UserEventPlugins"
        let lext = "Library/Extensions"
        let ulib = "usr/local/lib"
        
        _ = runCommandReturnString(binary: "/sbin/mount", arguments: ["-uw", dest])

        patchBool()
        
        
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
            let sour = "usb"

            var pass = installKext(dest: dest, kext: list, fold: fold)
            print("disableBT2", list, pass)

        }
        
        /*
         
         IOHIDFamily="IOHIDFamily.kext"
         IOUSBHostFamily="IOUSBHostFamily.kext"
         PlugIns="/Contents/PlugIns/"
         AppleUSBHostMergeProperties="AppleUSBHostMergeProperties.kext"
         Contents="/Contents/"
         Info="Info.plist"
         IOBluetoothFamily="IOBluetoothFamily.kext"
         AppleMCEReporterDisabler="AppleMCEReporterDisabler.kext"


         n
         printf "Mac Pro 3,1 Bluetooth 2 Disabler, Bluetooth 4 Enabler by StarPlayrX"
         n
         sleep 0.1
         ditto -v "$source$Info" "$destVolume$kext$IOUSBHostFamily$PlugIns$AppleUSBHostMergeProperties$Contents$Info"
         chown -R 0:0 "$destVolume$kext$IOUSBHostFamily$PlugIns$AppleUSBHostMergeProperties"
         chmod -R 755 "$destVolume$kext$IOUSBHostFamily$PlugIns$AppleUSBHostMergeProperties"
         touch "$destVolume$kext$IOUSBHostFamily$PlugIns$AppleUSBHostMergeProperties"

         
         */
    }
}








//No need for this yet
class TabView : NSTabView {
    override func awakeFromNib() {
        
    }
}
