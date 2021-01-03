//
//  postInstallAction.swift
//  bigmac2
//
//  Created by starplayrx on 1/1/21.
//

import Foundation

extension ViewController {
    
    @IBAction func patchDiskExec_action(_ sender: Any) {
        
        postInstallTask_label.stringValue = "Installing Selected Kexts..."
        postInstallDetails_label.stringValue = ""
        postInstallFuelGauge.doubleValue = 0
        postInstallProgressIndicator.doubleValue = 1
        postInstallSpinner.startAnimation(sender)
        postInstallSpinner.isHidden = false
        patchBool()
        
        
        DispatchQueue.global(qos: .background).async { [self] in
            PostInstall()
            
            DispatchQueue.main.async { [self] in
                indicatorBump(taskMsg: "Completed the selected patches...", detailMsg: "", updateProgBar: true)
                postInstallProgressIndicator.doubleValue += 1
                postInstallFuelGauge.doubleValue += 1
                postInstallFuelGauge.doubleValue = postInstallFuelGauge.maxValue
                postInstallProgressIndicator.doubleValue = postInstallProgressIndicator.maxValue
                postInstallSpinner.stopAnimation(sender)
                postInstallSpinner.isHidden = true
            }
        }
        
    }
}



