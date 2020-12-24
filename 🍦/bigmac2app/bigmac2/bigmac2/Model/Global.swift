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

typealias myVolumeInfo = (diskSlice: String, disk: String, name: String, path: String, uuid: String)


extension Notification.Name {
    static let gotEraseDisk = Notification.Name("gotEraseDisk")
    static let gotCreateDisk = Notification.Name("gotCreateDisk")
}


