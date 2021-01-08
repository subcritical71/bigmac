//
//  PostInstallController.swift
//  bigmac2
//
//  Created by starplayrx on 1/7/21.
//

import Cocoa

class PostInstallViewController : InstallViewController {
    
    @IBOutlet var creditsTextView: NSTextView!
    
    @IBAction func blessAndBoot(_ sender: Any) {
        dismiss(self)
    }
    
    @IBAction func Donate(_ sender: Any) {
        dismiss(self)
    }
    
    @IBAction func ThankYou(_ sender: Any) {
        dismiss(self)
    }
    
    override func viewDidLoad() {
        /*  if #available(OSX 10.15, *) {
         creditsTextView.font = .monospacedSystemFont(ofSize: 12, weight: NSFont.Weight.regular)
         } else {
         // Fallback on earlier versions
         creditsTextView.font = .monospacedDigitSystemFont(ofSize: 12, weight: NSFont.Weight.regular)
         
         }
         creditsTextView.textColor = .secondaryLabelColor*/
        
        var font1 = NSFont(name:"Menlo",size:12)
        var font2 = NSFont(name:"Menlo",size:13)

        if #available(OSX 10.15, *) {
            font1 = NSFont.monospacedSystemFont(ofSize: 12, weight: NSFont.Weight.regular)
            font2 = NSFont.monospacedSystemFont(ofSize: 13, weight: NSFont.Weight.regular)

        }
    
        creditsTextView.isRichText = true
        creditsTextView.isEditable = false
        creditsTextView.isSelectable = false
        
        let orange: [NSAttributedString.Key: Any] = [.font: font1!, .foregroundColor: NSColor.systemOrange]
        let green: [NSAttributedString.Key: Any] = [.font: font2!, .foregroundColor: NSColor.systemGreen]
        
        let sep1 = "—————————————————————————————–––––––––"
        let separate1 = NSMutableAttributedString(string: sep1)
        separate1.addAttributes(orange, range: NSRange(location: 0, length: sep1.count))
        creditsTextView.textStorage?.append(separate1)
        
        let credits = "🍺 Big Mac Hall of Fame"
        let creditsText = NSMutableAttributedString(string: credits)
        creditsText.addAttributes(green, range: NSRange(location: 0, length: credits.count + 1))
        creditsTextView.textStorage?.append(creditsText)
        
        let sep2 = "\n—————————————————————————————–––––––––"
        let separate2 = NSMutableAttributedString(string: sep2)
        separate2.addAttributes(orange, range: NSRange(location: 0, length: sep2.count))
        creditsTextView.textStorage?.append(separate2)
        
        let name1 = "\n🍎 StarPlayrX   - Big Mac 2.0\n"
        let nameA = NSMutableAttributedString(string: name1)
        nameA.addAttributes(green, range: NSRange(location: 0, length: name1.count + 1))
        creditsTextView.textStorage?.append(nameA)
        
        let name2 = "\n🍊 DosDude1     - APFS ROM Patcher\n"
        let nameB = NSMutableAttributedString(string: name2)
        nameB.addAttributes(green, range: NSRange(location: 0, length: name2.count + 1))
        creditsTextView.textStorage?.append(nameB)
        
        let name3 = "\n🍏 ASentientBot - Hax3 & USB 1.1\n"
        let nameC = NSMutableAttributedString(string: name3)
        nameC.addAttributes(green, range: NSRange(location: 0, length: name3.count + 1))
        creditsTextView.textStorage?.append(nameC)
        
        let name4 = "\n🍓 BarryKN      - Hax3 Updates\n"
        let nameD = NSMutableAttributedString(string: name4)
        nameD.addAttributes(green, range: NSRange(location: 0, length: name4.count + 1))
        creditsTextView.textStorage?.append(nameD)
        
        let name5 = "\n🫐 Czo          - SUVMMFaker\n"
        let nameE = NSMutableAttributedString(string: name5)
        nameE.addAttributes(green, range: NSRange(location: 0, length: name5.count + 1))
        creditsTextView.textStorage?.append(nameE)
        
        
        
        
        
        /*   creditsTextView.string =
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
         
         }*/
    }
}
