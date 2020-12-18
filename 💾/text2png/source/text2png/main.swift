//
//  main.swift
//  text2png
//
//  Created by X on 12/16/20.
//

import Foundation
import AppKit

extension NSImage {
    func tif2imageData() -> Data? {
        guard
            let tiff = self.tiffRepresentation(using: .lzw, factor: 1.0),
            let image = NSBitmapImageRep(data: tiff)
        else { return nil }
        let imageData = image.representation(
            using: .png,
            ///Compression Factor only works
            ///with .jpeg and .jpeg2000
            properties: [.compressionFactor : 1.0])
        return imageData
    }
    
    func savePNG(image: NSImage, path:String)  {
        
        let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
        let pngData = imageRep?.representation(using: .png, properties: [:])
        
        let url = NSURL(string: path)
        try? pngData?.write(to: url! as URL)
        
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

// MARK: Get System Info
func getSystemInfo(drive:String = "BMO") -> systemInfoCodable?   {
    
    let systemPath = "/Volumes/\(drive)/System/Library/CoreServices/SystemVersion.plist"
    //let systemURL = NSURL(string: systemPath)
    let systemURL = URL(fileURLWithPath: systemPath)
    
    var systemInfo : systemInfoCodable?
    do {
        let data = try Data(contentsOf: systemURL )
        let decoder = PropertyListDecoder()
        systemInfo = try decoder.decode(systemInfoCodable.self, from: data)
        
        return systemInfo
    } catch {
        // Handle error
        print(error)
    }
    
    return nil

}


func createArt(text: String = "BigMac") {
    
    var systemInfo : systemInfoCodable?
    var majorMinorVersion = [String]()
    
    if let sysInfo = getSystemInfo(drive: text) {
        majorMinorVersion = systemInfo?.productUserVisibleVersion.components(separatedBy: ".") ?? ["11","1"]
        systemInfo = sysInfo
    }
    
    var macOS = "Big Mac"
    
    let mm = ( major: (Int(majorMinorVersion[0]) ?? 11) as Int, minor: (Int(majorMinorVersion[1]) ?? 0) as Int )
    switch mm {
    case (major: 11, minor: _)  :
        macOS = "Big Sur"
    case (major: 10, minor: 16) :
        macOS = "Big Sur Beta"
    case (major: 10, minor: 15) :
        macOS = "Catalina"
    case (major: 10, minor: 14) :
        macOS = "Mojave"
    case (major: 10, minor: 11) :
        macOS = "High Sierra"
    case (major: 10, minor: 11) :
        macOS = "Sierra"
    case (major: 10, minor: 10) :
        macOS = "Yosemite"
    case (major: 10, minor: 9) :
        macOS = "Mavericks"
    case (major: 10, minor: 8) :
        macOS = "Mountain Lion"
    case (major: 10, minor: 7) :
        macOS = "Lion"
    case (major: 10, minor: 6) :
        macOS = "Snow Leopard"
    case (major: 10, minor: 5) :
        macOS = "Leopard"
    case (major: 10, minor: 4) :
        macOS = "Tiger"
    case (major: 10, minor: 3) :
        macOS = "Panther"
    case (major: 10, minor: 2) :
        macOS = "Jaguar"
    case (major: 10, minor: 1) :
        macOS = "Puma"
    case (major: 10, minor: 0) :
        macOS = "Cheetah"
    default:
        macOS = "Big Mac"
    }

    if let filename = text.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
        let OS = "\(systemInfo!.productName) \(macOS)"
        let build = "\(systemInfo!.productUserVisibleVersion) \(systemInfo!.productBuildVersion)"
        let label = "\(text)\n\n\n\(OS)\n\(build)"

        let img = NSImage(size: NSSize(width: 100, height: 100))
        let image = textToImage( image: img, text: label )

        let tmp = "tmp"
        let path = "file:///\(tmp)/\(filename).png"
        image.savePNG(image: image, path: path)
        print("/\(tmp)/\(filename).png")
    }
  
}



func textToImage(image: NSImage, text: String) -> NSImage {
    let font = NSFont.systemFont(ofSize: 7)
    let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    let textRect = CGRect(x: 0, y: 1.75, width: image.size.width, height: image.size.height)
    let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
    textStyle.alignment = .center
    textStyle.lineSpacing = 0.8
    
    var labelColor = NSColor.white
    
    if let textColor = CommandLine.arguments.last  {
        if textColor == "black" || textColor == "Black" {
            labelColor = NSColor.black
        }
    }
    
    let textFontAttributes = [
        NSAttributedString.Key.font: font,
        NSAttributedString.Key.foregroundColor: labelColor,
        NSAttributedString.Key.paragraphStyle: textStyle
    ]
    let im:NSImage = NSImage(size: image.size)
    let rep:NSBitmapImageRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(image.size.width), pixelsHigh: Int(image.size.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    im.addRepresentation(rep)
    im.lockFocus()
    image.draw(in: imageRect)
    text.draw(in: textRect, withAttributes: textFontAttributes)
    im.unlockFocus()
    return im
}




if let first = Optional(CommandLine.arguments[1]) {
    if !first.isEmpty && first.count < 32 {
        createArt(text: "\(first)")
    } else {
        print("/nUsage:/ntext2png LabelName white/black/n")
    }
}

