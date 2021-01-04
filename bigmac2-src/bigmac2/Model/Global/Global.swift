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

var enableUSB = true
var disableBT2 = true
var amdMouSSE = true
var teleTrap = true
var VerboseBoot = false
var superDrive = true
var appStoreMacOS = true
var appleHDA = true
var hdmiAudio = false
var singleUser = false
var legacyWiFi = false
var installKCs = true
var blessSystem = true
var deleteSnaphots = true

//MARK: - VolumeInfo
struct myVolumeInfo {
    var diskSlice, disk, displayName, volumeName, path, uuid: String
    var external, root: Bool
    var capacity: Int
}

// MARK: - Snapshots
struct Snapshots: Codable {
    let snapshots: [Snapshot]

    enum CodingKeys: String, CodingKey {
        case snapshots = "Snapshots"
    }
}

// MARK: - Snapshot
struct Snapshot: Codable {
    let limitingContainerShrink, purgeable: Bool
    let snapshotName, snapshotUUID: String
    let snapshotXID: Int

    enum CodingKeys: String, CodingKey {
        case limitingContainerShrink = "LimitingContainerShrink"
        case purgeable = "Purgeable"
        case snapshotName = "SnapshotName"
        case snapshotUUID = "SnapshotUUID"
        case snapshotXID = "SnapshotXID"
    }
}

// MARK: - System Info code
struct systemInfoCodable: Codable {
    let productVersion, productBuildVersion, productCopyright, productName: String
    let iOSSupportVersion, productUserVisibleVersion: String
    
    enum CodingKeys: String, CodingKey {
        case productVersion = "ProductVersion"
        case productBuildVersion = "ProductBuildVersion"
        case productCopyright = "ProductCopyright"
        case productName = "ProductName"
        case iOSSupportVersion
        case productUserVisibleVersion = "ProductUserVisibleVersion"
    }
}

