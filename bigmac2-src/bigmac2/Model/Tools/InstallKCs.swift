//
//  InstallKCs.swift
//  bigmac2
//
//  Created by starplayrx on 1/4/21.
//

import Foundation

extension ViewController {
    
     /* Update System Caches on macOS 11.1 */
     func updateMac11onMac11SystemCache(destVolume: String) {
         
         //MARK: Constants
         let appleSysLib     = "Library/Apple/System/Library"
         let appleSysLibExt  = "Library/Apple/System/Library/Extensions"
         let appleSysLibPre  = "Library/Apple/System/Library/PrelinkedKernels"
         let prelinkedkernel = "System/Library/PrelinkedKernels/prelinkedkernel"
         let sysLibExt       = "System/Library/Extensions"
         let sysLibDriverExt = "System/Library/DriverExtensions"
         let libExt          = "Library/Extensions"
         let libDriveExt     = "Library/DriverExtensions"
         let kernel          = "System/Library/Kernels/kernel"
         
         //MARK: Commands
         let touch =         "\(destVolume)usr/bin/touch"
         let kmutil =        "\(destVolume)usr/bin/kmutil"
                 
         let appleSysLibExists               = checkIfFileExists(path: "\(destVolume)\(appleSysLib)")
         let appleSysLibPreKernelsExists     = checkIfFileExists(path: "\(destVolume)\(appleSysLibPre)")

         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(appleSysLib)"])
         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(appleSysLibExt)"])
         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(sysLibExt)"])
         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(sysLibDriverExt)"])
         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(libExt)"])
         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(libDriveExt)"])
         
        indicatorBump(updateProgBar: true)
        DispatchQueue.global(qos: .background).async { [self] in
            runIndeterminateProcess(binary: kmutil, arguments: ["log", "stream"], title: "Updating Boot and System Kernel Extensions...")
        }
        
        let kmArrA = ["install", "--update-all", "--check-rebuild", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
        runIndeterminateProcess(binary: kmutil, arguments: kmArrA, title: "Updating Boot and System Kernel Extensions...")
        
         //MARK: Rechecking Extensions
        indicatorBump(taskMsg: "Verifying Boot and System Kernel Extensions...", detailMsg: "", updateProgBar: true)
        runIndeterminateProcess(binary: kmutil, arguments: kmArrA, title: "Verifying Boot and System Kernel Extensions...")
         
         //MARK: Updating Library Extensions
        indicatorBump(taskMsg: "Updating Auxiliary Kernel Extensions...", detailMsg: "", updateProgBar: true)
        let kmArrC = ["create", "-n", "aux", "--repository", "/\(libExt)", "--volume-root", "\(destVolume)"]
        runIndeterminateProcess(binary: kmutil, arguments: kmArrC, title: "Verifying Boot and System Kernel Extensions...")
        
        
        indicatorBump(taskMsg: "Creating Prelinked Kernel...", detailMsg: "", updateProgBar: true)
         if appleSysLibExists {
            indicatorBump(updateProgBar: true)
             if !appleSysLibPreKernelsExists {
                 _ = mkDir(arg: "\(destVolume)/\(appleSysLibPre)")
             }
             let kmArrA = ["create", "-n", "boot", "--boot-path", "/\(appleSysLibPre)/prelinkedkernel", "-f", "'OSBundleRequired'=='Local-Root'", "--kernel", "/\(kernel)", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
            runIndeterminateProcess(binary: kmutil, arguments: kmArrA, title: "Creating Prelinked Kernel...")
         } else {
            indicatorBump(updateProgBar: true)
             let kmArrA = ["create", "-n", "boot", "--boot-path", "/\(prelinkedkernel)", "-f", "'OSBundleRequired'=='Local-Root'", "--kernel", "/\(kernel)", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
             
            runIndeterminateProcess(binary: kmutil, arguments: kmArrA, title:"Creating Prelinked Kernel...")
         }
         
        //MARK: Stop kernel process
        runIndeterminateProcess(binary: "/usr/bin/killall", arguments: ["kmutil"], title: "Stopping kmutil monitor...")
        
        sleep(2)
        let kcditto = "\(destVolume)usr/sbin/kcditto"
        runIndeterminateProcess(binary: kcditto, arguments: [], title: "Updating Preboot Volume...")
        
    

        return
     }
}
