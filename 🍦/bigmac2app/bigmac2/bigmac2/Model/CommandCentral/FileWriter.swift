//
//  FileWriter.swift
//  bigmac2
//
//  Created by starplayrx on 12/29/20.
//

import Foundation

func txt2file(text: String, file: String) {

    //writing
    do {
        try text.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
    } catch {
       print(error)
    }
}




//reading
//do {
//    let text2 = try String(contentsOf: fileURL, encoding: .utf8)
//}
