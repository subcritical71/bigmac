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
    
    let apfs = "/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util"

    
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
    @IBOutlet weak var VerboseBoot_btn: NSButton!
    @IBOutlet weak var superDrive_btn: NSButton!
    @IBOutlet weak var appleHDA_btn: NSButton!
    @IBOutlet weak var hdmiAudio_btn: NSButton!
    @IBOutlet weak var appStoreMacOS_btn: NSButton!
    @IBOutlet weak var legacyWiFi_btn: NSButton!
    @IBOutlet weak var singleUser_btn: NSButton!
    @IBOutlet weak var postInstallFuelGauge: NSLevelIndicator!
    @IBOutlet weak var postInstallProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var availablePatchDisks: NSPopUpButton!
    @IBOutlet weak var patchDiskExecution_btn: NSButton!
    
    @IBOutlet weak var postInstallTask_label: NSTextField!
    @IBOutlet weak var postInstallDetails_label: NSTextField!
    
    @IBOutlet weak var postInstallSpinner: NSProgressIndicator!
    @IBOutlet weak var deleteAPFSSnapshotsButton: NSButton!
    @IBOutlet weak var BlessVolume: NSButton!
    @IBOutlet weak var updateBootSysKCs: NSButton!
    @IBOutlet weak var patchDisk_btn: NSButton!
    

    var enableUSB = Bool()
    var disableBT2 = Bool()
    var amdMouSSE = Bool()
    var teleTrap = Bool()
    var VerboseBoot = Bool()
    var superDrive = Bool()
    var appStoreMacOS = Bool()
    var appleHDA = Bool()
    var hdmiAudio = Bool()
    var singleUser = Bool()
    var legacyWiFi = Bool()
    var installKCs = Bool()
    var blessSystem = Bool()
    var deleteSnaphots = Bool()
    var driv = String()
    
    var enableUSBtl = String()
    var disableBT2tl = String()
    var amdMouSSEtl = String()
    var teleTraptl = String()
    var VerboseBoottl = String()
    var superDrivetl = String()
    var appStoreMacOStl = String()
    var appleHDAtl = String()
    var hdmiAudiotl = String()
    var singleUsertl = String()
    var legacyWiFitl = String()
    var installKCstl = String()
    var blessSystemtl = String()
    var deleteSnaphotstl = String()

    
    
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
    
    

}


//No need for this yet
class TabView : NSTabView {
    override func awakeFromNib() {
        
    }
}
