//
//  HelperAnimation.swift
//  Packtag
//
//  Created by Bernd Plontsch on 04/11/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit
import QuartzCore

class HelperAnimation: NSObject {
    
    let logSwitch:Bool = false
    
    class func startPulse (view:UIView) {
        //println("[Animation] Pulse")
        var changeAlpha:CABasicAnimation = CABasicAnimation(keyPath:"opacity") as CABasicAnimation
        changeAlpha.fromValue = 0.1
        changeAlpha.toValue = 0.4
        changeAlpha.duration = 0.8
        changeAlpha.repeatCount = 999
        changeAlpha.autoreverses = true
        view.layer.addAnimation(changeAlpha, forKey: "ChangeAlpha")
        view.layer.speed = 1.0;
    }

    class func stopPulse (view:UIView) {
        //println("[Animation] Stop Pulse")
        view.layer.removeAllAnimations()
    }

    class func pulse (view:UIView, loops:Float) {
        //println("[Animation] Pulse")
        var changeAlpha:CABasicAnimation = CABasicAnimation(keyPath:"opacity") as CABasicAnimation        
        changeAlpha.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        changeAlpha.fromValue = 0.15
        changeAlpha.toValue = 0.45
        changeAlpha.duration = 1.2
        changeAlpha.repeatCount = loops
        changeAlpha.autoreverses = true
        view.layer.addAnimation(changeAlpha, forKey: "ChangeAlpha")
        view.layer.speed = 1.0;
    }
    
}
