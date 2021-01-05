//
//  shakeExt.swift
//  bigmac2
//
//  Created by starplayrx on 1/4/21.
//

import Cocoa

extension NSView {
    func shake(duration: CFTimeInterval) {
        
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation]
        shakeGroup.duration = duration
        self.layer?.add(shakeGroup, forKey: "shakeIt")
    }
}
