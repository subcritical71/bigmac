//
//  FileDownloader.swift
//  bigmac2
//
//  Created by starplayrx on 12/19/20.
//


import Foundation
import AppKit


extension ViewController : URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) -> Void {
        let percentage = (Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)) * 100
        
        if  percentage != currDownload  {
            currDownload = percentage
            let a = round (Float(totalBytesWritten) / 1000 / 1000 / 1000 * 100 ) / 100
            let b = round (Float(totalBytesExpectedToWrite) / 1000 / 1000 / 1000 * 100 ) / 100
            let p = round (percentage * 100) / 100
            DispatchQueue.main.async {
                self.gbLabel.stringValue = "\(a) GB/ \(b) GB"
                self.progress.doubleValue = Double(percentage)
                self.percentageLabel.stringValue = "\(p)%"
                
               
            }
            
        }
    }

    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {

        do {
            let documentsURL = try
                FileManager.default.url(for: .downloadsDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            
            if let filename =  downloadTask.currentRequest?.url?.lastPathComponent {
                let savedURL = documentsURL.appendingPathComponent(
                    filename)
                try FileManager.default.moveItem(at: location, to: savedURL)
            }
        
            
        } catch {
            // handle filesystem error
        }
    }


}

