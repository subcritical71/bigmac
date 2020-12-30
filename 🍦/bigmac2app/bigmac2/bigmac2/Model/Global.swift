//
//  Global.swift
//  bigmac2
//
//  Created by starplayrx on 12/19/20.
//

import Foundation
import AppKit

var userName = ""
var passWord = ""
var rootMode = false

//typealias myVolumeInfo = (diskSlice: String, disk: String, name: String, path: String, external: Bool, uuid: String)

struct myVolumeInfo {
    var diskSlice, disk, displayName, volumeName, path, uuid: String
    var external: Bool
    var capacity: Int
}


extension Notification.Name {
    static let gotEraseDisk = Notification.Name("gotEraseDisk")
    static let gotCreateDisk = Notification.Name("gotCreateDisk")
    static let gotAppChanged = Notification.Name("gotAppChanged")

}





