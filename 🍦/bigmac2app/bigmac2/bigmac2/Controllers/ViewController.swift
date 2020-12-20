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
    @IBOutlet weak var progress: NSProgressIndicator!
    @IBOutlet weak var buildLabel: NSTextField!
    @IBOutlet weak var gbLabel: NSTextField!
    @IBOutlet weak var percentageLabel: NSTextField!
    
    internal var running: Bool = false
    var currDownload: Float = -1.00
    
    @IBAction func downloadMacOSAction(_ sender: Any) {
        progress.doubleValue = 0
        progress.isIndeterminate = false
        downloadPkg()
    }
   
    //MARK Phase 2 Downloader
    @IBAction func createInstallDisk(_ sender: Any) {
        //To Do add check
        
        
        //export SUDO_ASKPASS=/usr/local/bin/ssh-askpass
       // let howmeDirURL = URL(fileURLWithPath: NSHomeDirectory())

        DispatchQueue.global(qos: .background).async {
            let a = runCommandReturnString(binary: "/usr/bin/osascript" , arguments: ["-e", "do shell script \"sudo installer -pkg ~/Downloads/InstallAssistant.pkg -target /\" user name \"\(userName)\" password \"\(passWord)\" with administrator privileges"])
             print(a)
        }
        
        if userName.isEmpty || passWord.isEmpty {
            
        }

        //let a = runCommandReturnString(binary: "/usr/bin/sudo" , arguments: ["-A", "installer","-pkg", "~/Downloads/InstallAssistant.pkg", "-target", "/"])
       // print(a)
       //
       // let a = runCommandReturnString(binary: "/usr /bin/sudo" , arguments: ["-A", "installer","-pkg", "~/Downloads/InstallAssistant.pkg", "-target", "/"])
        //print(a)
    }
    
    override func viewWillAppear() {
        super.viewDidAppear()
        view.window?.title = "🍔 Big Mac 2.0"
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
        progress.doubleValue = 0 //set progressBar to 0 at star
        
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






