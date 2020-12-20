//
//  ViewController.swift
//  bigmac2
//
//  Created by starplayrx on 12/18/20.
//

import AppKit
import Foundation


class ViewController: NSViewController, URLSessionDelegate {
    
    //Constants
    
    //get Home Folder
    let homeFolder = NSString(string: "~/").expandingTildeInPath
    
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
    
    internal var running: Bool = false
    var currDownload: Float = -1.00
    
    @IBAction func downloadMacOSAction(_ sender: Any) {
        progressBarDownload.doubleValue = 0
        progressBarDownload.isIndeterminate = false
        downloadPkg()
    }
   
    //MARK Phase 2 Downloader
    @IBAction func createInstallDisk(_ sender: Any) {
        //To Do add check
        
        installerFuelGauge.doubleValue = 0

        //export SUDO_ASKPASS=/usr/local/bin/ssh-askpass
       // let howmeDirURL = URL(fileURLWithPath: NSHomeDirectory())
        
        var runner = true
        
        if userName.isEmpty || passWord.isEmpty {
            runner = false
        } else {
            createInstallSpinner.startAnimation(sender)
        }
        
        let appFolder = Bundle.main.resourceURL
        /*if ( runner ) {
            DispatchQueue.global(qos: .background).async {
                _ = runCommandReturnString(binary: "/usr/bin/osascript" , arguments: ["-e", "do shell script \"sudo installer -pkg ~/Downloads/InstallAssistant.pkg -target /\" user name \"\(userName)\" password \"\(passWord)\" with administrator privileges"])
                DispatchQueue.main.async { [self] in
                    installerFuelGauge.doubleValue += 1
                }
            }
        }*/
   
        if ( runner ) {
            DispatchQueue.global(qos: .background).async {
                let appFolder = Bundle.main.resourceURL
                let dmgPath = "\(appFolder!.path)/bigmac2.dmg"
                
             /*   _ = runCommandReturnString(binary: "/usr/bin/osascript" , arguments: ["-e", "do shell script \"mkdir /tmp/bm2a; printf '%s' 'F4D44526E1CFEA5DDF55004207B5A1044AAB8B13A5B6706A2CF12E9EF50CADAD' | hdiutil attach /Users/starplayrx/bigmac2_starter_sha256.dmg -mountpoint /tmp/bm2a -noverify -nobrowse  -stdinpass\""])*/
                
                
                if ( runner ) {
                    DispatchQueue.global(qos: .background).async {
                        let asr  = runCommandReturnString(binary: "/usr/bin/osascript" , arguments: ["-e", "do shell script \"sudo asr -s \(dmgPath) -t \(installerVolume) -er -nov -nop\" user name \"\(userName)\" password \"\(passWord)\" with administrator privileges"])
                        print(asr)
                        DispatchQueue.main.async { [self] in
                            
                            if asr.contains("Restore completed successfully") {
                                installerFuelGauge.doubleValue += 1
                            }
                        }
                    }
                }
                
                
                DispatchQueue.main.async { [self] in
                    installerFuelGauge.doubleValue += 1
                }
                
                
            }
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            createInstallSpinner.stopAnimation(sender)
        }

    }
    
    override func viewWillAppear() {
        super.viewDidAppear()
        view.window?.title = "🍔 Big Mac 2.0"
        installerFuelGauge.doubleValue = 0
    }
  
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.level = .floating
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if NSUserName() != "root" && (passWord.isEmpty || userName.isEmpty) {
                self.performSegue(withIdentifier: "userNamePassWord", sender: self)
            }
        }
        
    

        
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarDownload.doubleValue = 0 //set progressBar to 0 at star
        
        let howmeDirURL = URL(fileURLWithPath: NSHomeDirectory())

        print(howmeDirURL)
    }
    
    internal func download(urlString: String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self as URLSessionDelegate, delegateQueue: nil)
        let url = NSURL(string: urlString)
        let task = session.downloadTask(with: url! as URL)
        task.resume()
    }
    
    func downloadPkg() {
        //Remove pre-existing file
        _ = runCommandReturnString(binary: "/bin/rm", arguments: ["-Rf","\(homeFolder)/InstallAssistant.pkg"]) //Future check if it's complete and has right checksum
   
        DispatchQueue.global(qos: .background).async {
            self.download(urlString: "http://swcdn.apple.com/content/downloads/00/55/001-86606-A_9SF1TL01U7/5duug9lar1gypwunjfl96dza0upa854qgg/InstallAssistant.pkg")
        }
    }
    
}






