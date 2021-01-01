//
//  ViewController.swift
//  bigmac2
//
//  Created by starplayrx on 12/18/20.
//

import Cocoa




class ViewController: NSViewController, URLSessionDelegate  {
    

   
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
    
 
    @IBOutlet weak var tabViews: NSTabView!
    @IBOutlet weak var downloadsTab: NSTabViewItem!
    @IBOutlet weak var preInstallTab: NSTabViewItem!
    @IBOutlet weak var postInstallTab: NSTabViewItem!
    @IBOutlet weak var cloneToolTab: NSTabViewItem!
    
    @IBOutlet weak var HiRes_1080: NSButton!
    @IBOutlet weak var LowRes_1080: NSButton!
    @IBOutlet weak var HiRes_720: NSButton!
    @IBOutlet weak var LowRes_720: NSButton!
    
    let setResX = "/Applications/RDM.app/Contents/MacOS/SetResX"
    let baseOS = "/Install macOS Big Sur.app/Contents/MacOS/InstallAssistant"
    
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
    
    @IBAction func LoRes_720(_ sender: Any) {
        _ = runCommandReturnString(binary: setResX, arguments: ["-w", "1280", "-h", "720", "-s", "1", "-b", "16"])
    }
    @IBAction func HiRes_720(_ sender: Any) {
        _ = runCommandReturnString(binary: setResX, arguments: ["-w", "1280", "-h", "720", "-s", "2", "-b", "16"])
    }
    @IBAction func LoRes_1080(_ sender: Any) {
        _ = runCommandReturnString(binary: setResX, arguments: ["-w", "1920", "-h", "1080", "-s", "1", "-b", "16"])
    }
    
    @IBAction func HiRes_1080(_ sender: Any) {
        _ = runCommandReturnString(binary: setResX, arguments: ["-w", "1920", "-h", "1080", "-s", "2", "-b", "16"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseBootArgs()
        disableSetResXButtonsCheck()
        bootedToBaseOS = checkForBaseOS()
        
        if ( bootedToBaseOS) {
            tabViews.selectTabViewItem(preInstallTab)
            tabViews.selectTabViewItem(downloadsTab)
            tabViews.selectTabViewItem(postInstallTab)
            tabViews.selectTabViewItem(cloneToolTab)
            tabViews.selectTabViewItem(preInstallTab)
            tabViews.drawsBackground = false
        }

    }
}

class TabView : NSTabView {
    
    override func awakeFromNib() {
    }
    
}
