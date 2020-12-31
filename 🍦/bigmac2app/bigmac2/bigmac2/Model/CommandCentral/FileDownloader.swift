//
//  FileDownloader.swift
//  bigmac2
//
//  Created by starplayrx on 12/19/20.
//


import Foundation
import AppKit
//import AppleScriptObjC

extension ViewController : URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) -> Void {
        
        let x = round (Float(totalBytesWritten) / 1000 / 1000 / 10 ) / 100
        
        if x != downloadProgress {
          
            let a = round (Float(totalBytesWritten) / 1000 / 1000 / 10 ) / 100
            let b = round (Float(totalBytesExpectedToWrite) / 1000 / 1000 / 10 ) / 100
            
            if ( a / b ).isNaN || ( a / b ).isInfinite { return }

            let percentageDouble = Double ( a / b * 100 )
            
            let percentageInt = Int ( a / b * 100 )
            
            DispatchQueue.main.async { [self] in
                gbLabel.stringValue = "\(a) GB / \(b) GB"
                progressBarDownload.doubleValue = percentageDouble
                percentageLabel.stringValue = "\(percentageInt)%"
            }
            
            downloadProgress = x
        }
      
      
    }
    
    //to do add error handling
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        let fileManager = FileManager.default
        
        let documentsURL = try?
            fileManager.url(for: .userDirectory,
                            in: .allDomainsMask,
                                    appropriateFor: nil,
                                    create: false)
        if let filename  = downloadTask.currentRequest?.url?.lastPathComponent {
            let savedURL = documentsURL?.appendingPathComponent (
                shared + filename)
            
            if let savedURL = savedURL {
                try? fileManager.moveItem(at: location, to: savedURL)
                
              if filename == bigmacDisk {
                   NotificationCenter.default.post(name: .gotCreateDisk, object: nil)
                }
            }
        }
    }
    
     func download(urlString: String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self as URLSessionDelegate, delegateQueue: nil)
        
        if let url = NSURL(string: urlString) {
            let task = session.downloadTask(with: url as URL)
            task.resume()
        }
    }
    
    
    func startCopy() {
        if let targetPath = targetPath, let sourcePath = sourcePath {
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: targetPath) == true {
                try? fileManager.removeItem(atPath: targetPath)
            }
            
            if fileManager.fileExists(atPath: targetPath) == false {
                try? fileManager.copyItem(atPath: sourcePath, toPath: targetPath)
            }
        }
           
        DispatchQueue.main.async { [self] in
            createInstallSpinner.isHidden = false
            createInstallSpinner.stopAnimation(self)
        }
    }
    
    @objc func checkFileSize() {
        DispatchQueue.main.async(execute: { [self] in
            let fileManager = FileManager.default

            let fileSize = try? fileManager.attributesOfItem(atPath: sourcePath!)[FileAttributeKey.size] as? Double
            let fileSizeTarget = try? fileManager.attributesOfItem(atPath: targetPath!)[FileAttributeKey.size] as? Double
            
            if let fileSizeTarget = fileSizeTarget, let fileSize = fileSize {
                
                if fileSize.isInfinite || fileSize.isNaN { return }
                if fileSizeTarget.isInfinite || fileSizeTarget.isNaN { return }
                
                let gigsCopied = round ( fileSizeTarget / 1000 / 1000 / 10 ) / 100
                let gigsTotal = round ( fileSize / 1000 / 1000 / 10 ) / 100
                let percentageDouble = Double(gigsCopied / gigsTotal * 100)
                let percentageInt = Int(gigsCopied / gigsTotal * 100)

                sharedSupportProgressBar.doubleValue = percentageDouble
                sharedSupportPercentage.stringValue = "\(percentageInt)%"
                sharedSupportGbLabel.stringValue = "\(gigsCopied) GB / \(gigsTotal) GB"
                
                if ( gigsCopied == gigsTotal && gigsCopied != 0.0 && gigsTotal != 0  ) {
                    timer?.invalidate()
                    createInstallSpinner.stopAnimation(self)
                    createInstallSpinner.isHidden = true
                }
            }
        })
    }
    
    
    func copyFile(atPath sourcePath: String?, toPath targetPath: String?) {
        DispatchQueue.main.async { [self] in

            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [self] timer in
                checkFileSize()
            }
        }
      
        self.sourcePath = sourcePath
        self.targetPath = targetPath
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: self.targetPath ?? "") == true {
            do {
                try fileManager.removeItem(atPath: self.targetPath ?? "")
            } catch {
            }
        }
        
        startCopy()
        
    }
}


