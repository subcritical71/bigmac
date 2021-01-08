//
//  PostInstallController.swift
//  bigmac2
//
//  Created by starplayrx on 1/7/21.
//

import Cocoa

class PostInstallViewController : InstallViewController {
    
    @IBOutlet var creditsTextView: NSTextView!
   
    override func viewDidLoad() {
        if #available(OSX 10.15, *) {
            creditsTextView.font = .monospacedSystemFont(ofSize: 12, weight: NSFont.Weight.regular)
        } else {
            // Fallback on earlier versions
            creditsTextView.font = .monospacedDigitSystemFont(ofSize: 12, weight: NSFont.Weight.regular)

        }
        creditsTextView.textColor = .secondaryLabelColor
        creditsTextView.string =
"""
Credits:
———————————————————————————————
• StarplayrX   - Big Mac 2.0
• DosDude1     - APFS ROM Patcher
• ASentientBot - Hax3
• BarryKN      - Hax3 Updates
• Czo          - SUVMMFaker
•
———————————————————————————————

"""
        
    }
}
