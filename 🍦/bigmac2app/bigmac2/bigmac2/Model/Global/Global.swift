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

var isBaseSingleUser = false
var isBaseVerbose = false

var isSysSingleUser = false
var isSysVerbose = false

var bigmacDisk = "bigmac2.dmg"
var bigmac2Str = "bigmac2"

var volumeInfo = myVolumeInfo(diskSlice: "", disk: "", displayName: "", volumeName: "", path: "", uuid: "", external: false, root: false, capacity: 0)

var ranHax3 = false

var bootedToBaseOS = false

//typealias myVolumeInfo = (diskSlice: String, disk: String, name: String, path: String, external: Bool, uuid: String)

struct myVolumeInfo {
    var diskSlice, disk, displayName, volumeName, path, uuid: String
    var external, root: Bool
    var capacity: Int
}






