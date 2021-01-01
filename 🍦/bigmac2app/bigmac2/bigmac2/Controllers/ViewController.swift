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
    @IBOutlet weak var HiDPI_Retina: NSButton!
    
    let installAsstBaseOS = "/Applications/RDM.app/Contents/MacOS/SetResX"
    
    func disableRetinaBtnCheck() {
        if !fm.fileExists(atPath: installAsstBaseOS) {
            HiDPI_Retina.isEnabled = false
            HiDPI_Retina.isHidden = true

        }
    }
    
    @IBAction func hiDPI(_ sender: Any) {
        _ = runCommandReturnString(binary: "/Applications/RDM.app/Contents/MacOS/SetResX", arguments: ["-w", "1920", "-h", "1080", "-s", "2", "-b", "32"])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        parseBootArgs()
        disableRetinaBtnCheck()
    }
}
