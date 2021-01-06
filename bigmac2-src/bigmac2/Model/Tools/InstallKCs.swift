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
         let kcditto =       "\(destVolume)usr/sbin/kcditto"
                 
         let appleSysLibExists               = checkIfFileExists(path: "\(destVolume)\(appleSysLib)")
         let appleSysLibPreKernelsExists     = checkIfFileExists(path: "\(destVolume)\(appleSysLibPre)")

         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(appleSysLib)"])
         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(appleSysLibExt)"])
         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(sysLibExt)"])
         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(sysLibDriverExt)"])
         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(libExt)"])
         _ = runCommandReturnString(binary: touch, arguments: ["\(destVolume)\(libDriveExt)"])
         
        indicatorBump(updateProgBar: true)

        //MARK: Updating All Kernel Extensions
         let kmArrA = ["install", "--update-all", "--check-rebuild", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
         runIndeterminateProcess(binary: kmutil, arguments: kmArrA, title: "Updating All Kernel Extensions...")
         
            indicatorBump(updateProgBar: true)

         //MARK: Rechecking Extensions
         let kmArrRE = ["install", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
         runIndeterminateProcess(binary: kmutil, arguments: kmArrRE, title: "Rechecking Extensions...")
         
        indicatorBump(updateProgBar: true)

         //MARK: Updating Library Extensions
         let kmArrB = ["install", "--check-rebuild", "--repository", "/\(libExt)", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
         runIndeterminateProcess(binary: kmutil, arguments: kmArrB, title: "Updating Library Extensions...")
     

         if appleSysLibExists {
            
            indicatorBump(updateProgBar: true)

             if !appleSysLibPreKernelsExists {
                 _ = mkDir(arg: "\(destVolume)/\(appleSysLibPre)")
             }
             
             let kmArrA = ["create", "-n", "-boot", "--boot-path", "\(appleSysLibPre)", "-f", "'OSBundleRequired'=='Local-Root'", "--kernel", "/\(kernel)", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
             
            _ = runCommandReturnString(binary: kmutil, arguments: kmArrA)
             

         } else {
            
            indicatorBump(updateProgBar: true)

             
             let kmArrA = ["create", "-n", "-boot", "--boot-path", "/\(prelinkedkernel)", "-f", "'OSBundleRequired'=='Local-Root'", "--kernel", "/\(kernel)", "--repository", "/\(sysLibExt)", "--repository", "/\(libExt)", "--repository", "/\(sysLibDriverExt)", "--repository", "/\(libDriveExt)", "--repository", "/\(appleSysLibExt)", "--volume-root", "\(destVolume)"]
             
            _ = runCommandReturnString(binary: kmutil, arguments: kmArrA)
             

             
         }
         
         indicatorBump(updateProgBar: true)

         _ = runCommandReturnString(binary: kcditto, arguments: [])
         
         indicatorBump(updateProgBar: true)

     }
}
