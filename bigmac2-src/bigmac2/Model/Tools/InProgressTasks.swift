//
//  InProgressTasks.swift
//  bigmac2
//
//  Created by starplayrx on 1/14/21.
//

import Foundation

//MARK: In Progess Flow
extension ViewController {
    
    func mask() {
        guard globalDispatch == nil && globalWorkItem == nil else {
            performSegue(withIdentifier: "namedTask", sender: self)
            return
        }
    }
    
    func que(label: String, function: () ) {
        
        globalWorkItem = DispatchWorkItem { function }
        globalDispatch = DispatchQueue(label: label)
        
        if let d = globalDispatch, let w = globalWorkItem {
            d.async(execute: w)
        }
    }
   
    func dosDude1inProgressTask(label: String, dmg: String) {
        mask()
        
        if let r = Bundle.main.resourceURL?.path, let p  =  Optional(r + "/" + dmg), checkIfFileExists(path: p) {
            _ = mountDiskImage(arg: ["mount", "\(p)", "-noverify", "-noautofsck", "-autoopen"])
        } else {
            globalWorkItem = DispatchWorkItem { [self] in downloadDMG(diskImage: dmg, webSite: globalWebsite) }
            globalDispatch = DispatchQueue(label: label)
            
            if let d = globalDispatch, let w = globalWorkItem {
                d.async(execute: w)
            }
        }
    }
    
    
    func downloadMacOSTask(label: String = "Downloading macOS", urlString: String = "http://swcdn.apple.com/content/downloads/00/55/001-86606-A_9SF1TL01U7/5duug9lar1gypwunjfl96dza0upa854qgg/InstallAssistant.pkg") {
        mask()
        
        let function: () = downloadPkg(pkgString : urlString).self

        que(label: label, function: function)

    }
    
    
    
}


