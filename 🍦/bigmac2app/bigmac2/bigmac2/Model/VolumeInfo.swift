//
//  VolumeInfo.swift
//  bigmac2
//
//  Created by starplayrx on 12/23/20.
//

import Foundation

func getVolumeInfo() -> [myVolumeInfo]? {
    
    let URLResourceKeys : [URLResourceKey] = [.volumeNameKey, .volumeIsRemovableKey, .volumeIsBrowsableKey, .volumeIsLocalKey, .volumeIsReadOnlyKey, .volumeIsInternalKey, .volumeIsAutomountedKey, .volumeIsEjectableKey, .volumeUUIDStringKey, .isWritableKey, .volumeIdentifierKey, .volumeLocalizedFormatDescriptionKey, .volumeLocalizedNameKey]

    let volumes = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: URLResourceKeys, options: [FileManager.VolumeEnumerationOptions.skipHiddenVolumes])

    if let session = DASessionCreate(kCFAllocatorDefault)  {
        if let drive = volumes {
            
            var volArray = [myVolumeInfo]()
            var volDict = [String:myVolumeInfo]()
            
            for disk in drive {
                
                let dp = String(disk.path)
                
                if dp.contains("/Volumes/")  {
                    
                    var newVolume : myVolumeInfo = (diskSlice: "", disk: "", name: "", path: "", uuid: "")
                    
                    if let disk = DADiskCreateFromVolumePath(kCFAllocatorDefault, session, disk as CFURL), let bsdName = DADiskGetBSDName(disk), let desc = DADiskCopyDescription(disk)  {
                        
                        newVolume.diskSlice = String(cString : bsdName)
                        
                        let desc = NSDictionary(dictionary : desc)
                        
                        newVolume.disk = "disk\(desc["DAMediaBSDUnit"] ?? "")"
                    }
                    
                    
                    if let info = try? disk.resourceValues(forKeys: Set(URLResourceKeys)) {
                        
                        newVolume.name = info.volumeName ?? ""
                        newVolume.uuid = info.volumeUUIDString ?? ""
                        newVolume.path = disk.path
                        newVolume.name = newVolume.path.replacingOccurrences(of: "/Volumes/", with: "" )

                    }
                    
                    volArray.append(newVolume)
                    volDict[newVolume.name] = newVolume
                }
            }
            return volArray
        }
    }
    return nil
}
