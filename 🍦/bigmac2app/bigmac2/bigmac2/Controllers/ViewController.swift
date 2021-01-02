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
        
                
        var isMatch = false
        var isRoot = false
        var systemVolume : myVolumeInfo!
        systemVolume = getVolumeInfoByDisk(filterVolumeName: driv, disk: "")
        
        //MARK: Confirm we have a match
        ///This is a good practice and should be used when checking disks in the downloads areas
        if systemVolume == nil  {
            systemVolume = getVolumeInfoByDisk(filterVolumeName: "/", disk: "", isRoot: true)
            if systemVolume.displayName == driv {
                isMatch = true
                isRoot = true
            }
        } else if systemVolume.volumeName == driv {
            isMatch = true
        }
        
        //MARK: Decided what to do because things are not right
        if systemVolume == nil {
            return
        }
        
        //Get the preboot volume next
        //let volInfo = getVolumeInfo(includeHiddenVolumes: true, includeRootVol: true, includePrebootVol: true )
        
        //let disks = volInfo?.filter { $0.disk == systemVolume.disk }
    
        let pb = runCommandReturnString(binary: "/usr/sbin/diskutil", arguments: ["list", "\(systemVolume.disk)"]) ?? ""
        
        let pbArray = pb.components(separatedBy: "\n")
        
        for i in pbArray {
            if i.contains("Preboot") {
                print(i.suffix(systemVolume.disk.count + 2))
            }
        }
        
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
        
        //             if let system = getVolumeInfoByDisk(filterVolumeName: systemVolume.volumeName, disk: systemVolume.disk) {

        
        
       
        
        func BootItUp(system: myVolumeInfo, isVerbose: Bool, isSingleUser: Bool) {
            
                //MARK: Make Preboot bootable and compatible with C-Key at boot time
                if let appFolder = Bundle.main.resourceURL {
                    let bootPlist = "com.apple.Boot.plist"
                    let platformPlist = "BuildManifest.plist"
                    let buildManifestPlist = "PlatformSupport.plist"
                    
                    let appFolderPath = "\(appFolder.path)"
                    
                    //Install Boot plist
                    
                    let _ = mkDir(arg: "/Volumes/Preboot/\(system.uuid)/restore/")
                    

                    
                    
                    print("Making System Disk Bootable...\n")
                    
                    if system.root {
                        
                        try? fm.removeItem(atPath: "/Volumes/\(system.volumeName)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                        try? fm.removeItem(atPath: "/Volumes/\(system.volumeName)/System/Library/CoreServices/\(platformPlist)")
                        try? fm.removeItem(atPath: "/System/Volumes/Preboot/\(system.uuid)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                        try? fm.removeItem(atPath: "/System/Volumes/Preboot/\(system.uuid)/System/Library/CoreServices/\(platformPlist)")
                        try? fm.removeItem(atPath: "/System/Volumes/Preboot/\(system.uuid)/restore/\(buildManifestPlist)")
                        
                    } else {
                        
                        try? fm.removeItem(atPath: "/Library/Preferences/SystemConfiguration/\(bootPlist)")
                        try? fm.removeItem(atPath: "/System/Library/CoreServices/\(platformPlist)")
                        try? fm.removeItem(atPath: "/System/Volumes/Preboot/\(system.uuid)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                        try? fm.removeItem(atPath: "/System/Volumes/Preboot/\(system.uuid)/System/Library/CoreServices/\(platformPlist)")
                        try? fm.removeItem(atPath: "/System/Volumes/Preboot/\(system.uuid)/restore/\(buildManifestPlist)")
                        
                    }
                  
                    
                    var verbose = "-v "
                    var singleUser = "-s "
                    
                    if !isVerbose {
                        verbose = ""
                    }
                    
                    if !isSingleUser {
                        singleUser = ""
                    }
                    
//Write our pList file
let bootPlistTxt =
"""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Kernel Flags</key>
        <string>\(singleUser)\(verbose)-no_compat_check -amfi_get_out_of_my_way=1</string>
    </dict>
</plist>
"""
                    if system.root {
                        
                        txt2file(text: bootPlistTxt, file: "/Library/Preferences/SystemConfiguration/\(bootPlist)")
                        try? fm.copyItem(atPath: "/\(appFolderPath)/\(bootPlist)", toPath: "/System/Library/CoreServices/\(platformPlist)")

                        txt2file(text: bootPlistTxt, file: "/System/Volumes/Preboot/\(system.uuid)/Library/Preferences/SystemConfiguration/\(bootPlist)")
                        try? fm.copyItem(atPath: "/\(appFolderPath)/\(bootPlist)", toPath: "/System/Volumes/Preboot/\(system.uuid)/System/Library/CoreServices/\(platformPlist)")
                        try? fm.copyItem(atPath: "/\(appFolderPath)/\(bootPlist)", toPath: "/System/Volumes/Preboot/\(system.uuid)/restore/\(buildManifestPlist)")
                        
                    } else {
                        
                    }
          
                   
                }
                

        }

       /*
         
         
         #cp "$bootdisk$bigsur$bootplist" "$(pwd)$systemconfig$bootplist"
         ditto -v "$bootdisk$bigsur$bootplist" "$destVolume$systemconfig$bootplist"
         chmod 755 "$destVolume$systemconfig$bootplist"
         chown 0:0 "$destVolume$systemconfig$bootplist"

         ditto -v "$bootdisk$bigsur$platformsupport" "$destVolume$coreservices$platformsupport"
         chmod 755 "$destVolume$coreservices$platformsupport"
         chown 0:0 "$destVolume$coreservices$platformsupport"

         #Preboot workusb

         n
         printf "Loading preboot..."
         preboot=$( diskutil list $destVolume | grep Preboot | grep disk | awk '{ printf $7 }' )


         prebootlocation=$bigmac$ghost
         prebootid=""
         loc=""
         slash=""

         restoremanifest="/restore/BuildManifest.plist"

         if [ $destVolume != "/" ]
             then
               printf "Testing Preboot mount..."
               test=$(diskutil unmount force "$preboot")
               printf "Mounting Preboot Volume..."
               diskutil mount -mountPoint "$prebootlocation" "$preboot"
               sleep 1
               prebootid=$( diskutil info "$destVolume" | grep Group | awk '{ printf $4 }' )
               loc=$prebootlocation$prebootid$slash

             else
               #Preboot Volumes are already mounted on Startup disks
               prebootlocation="/System/Volumes/Preboot/"
               prebootid=$( diskutil info / | grep Group | awk '{ printf $4 }' )
               loc=$prebootlocation$prebootid$slash
               echo $loc
         fi


         if [ ! -d "$prebootlocation$prebootid" ]
             then
                 echo "Could not find Preboot Volume exiting... If this persists, reboot."
                 diskutil umount force $preboot
                 exit 0
         fi

         sleep 1

         n
         ditto -v "$bootdisk$bigsur$bootplist" "$loc$systemconfig$bootplist"
         chmod 755 "$loc$systemconfig$bootplist"
         chown 0:0 "$loc$systemconfig$bootplist"

         ditto -v "$bootdisk$bigsur$buildmanifest" "$loc$restoremanifest"
         chmod 755 "$loc$restoremanifest"
         chown 0:0 "$loc$restoremanifest"

         ditto -v "$bootdisk$bigsur$platformsupport" "$loc$coreservices$platformsupport"
         chmod 755 "$loc$coreservices$platformsupport"
         chown 0:0 "$loc$coreservices$platformsupport"

         #If it's not the startup disk unmount the Preboot volume
         if [ "$destVolume" != "/" ]
             then
                 n
                 diskutil unmount force "$preboot"
         fi
         
         
         */
    }
}








//No need for this yet
class TabView : NSTabView {
    override func awakeFromNib() {
        
    }
}
