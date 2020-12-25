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

    var installerVolume = "/Volumes/bigmac2"
    var timer: Timer?
    let shared = "Shared/" //copy to shared directory

    var getEraseDisk : ()? = nil
    var getCreateDisk : ()? = nil
    
    @IBOutlet weak var mediaLabel: NSTextField!
    
    internal var running: Bool = false

    
    //MARK: Downloads Tab -- To Do should we use a TabView Controller
    @IBOutlet weak var progressBarDownload: NSProgressIndicator!
    @IBOutlet weak var buildLabel: NSTextField!
    @IBOutlet weak var gbLabel: NSTextField!
    @IBOutlet weak var percentageLabel: NSTextField!
    @IBOutlet weak var createInstallSpinner: NSProgressIndicator!
    @IBOutlet weak var installerFuelGauge: NSLevelIndicator!
    @IBOutlet weak var sharedSupportProgressBar: NSProgressIndicator!
    @IBOutlet weak var sharedSupportPercentage: NSTextField!
    @IBOutlet weak var sharedSupportGbLabel: NSTextField!

    @IBAction func downloadMacOSAction(_ sender: Any) {
        progressBarDownload.doubleValue = 0
        progressBarDownload.isIndeterminate = false
        downloadPkg()
    }

    //MARK: Phase 1.0
    @IBAction func createInstallDisk(_ sender: Any) {
        //Erase a Disk first
        self.performSegue(withIdentifier: "eraseDisk", sender: self)
    }

    //MARK: Phase 1.1
    @objc func gotEraseDisk(_ notification:Notification){
        //Got permission to erase a disk, proceed with disk workflow
        disk(isBeta: false, diskInfo: notification.object as! myVolumeInfo)
    }
    
    @objc func gotCreateDisk(_ notification:Notification){
        print("gotCreateDisk")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarDownload.doubleValue = 0 //set progressBar to 0 at star
        if NSUserName() == "root" {
            rootMode = true
        } else {
            rootMode = false
        }
    
        getEraseDisk = NotificationCenter.default.addObserver(self, selector: #selector(gotEraseDisk), name: .gotEraseDisk, object: nil)
        getCreateDisk = NotificationCenter.default.addObserver(self, selector: #selector(gotCreateDisk), name: .gotCreateDisk, object: nil)
    }
        
    override func viewWillAppear() {
        super.viewDidAppear()
        view.window?.title = "🍔 Big Mac 2.0"
        installerFuelGauge.doubleValue = 0
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.level = .floating
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            
            print(NSUserName())
            if NSUserName() != "root" && (passWord.isEmpty || userName.isEmpty) {
                self.performSegue(withIdentifier: "userNamePassWord", sender: self)
                //let result =  performAppleScript(script: "return  \"HELLO TODD BOSS\"") //add permissions check
            }
        }
    }
}
