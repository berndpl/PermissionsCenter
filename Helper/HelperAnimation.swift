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
    
    class func pulse (view:UIView) {
        println("PULSE")
        var changeAlpha:CABasicAnimation = CABasicAnimation(keyPath:"opacity") as CABasicAnimation
        changeAlpha.fromValue = 0.1
        changeAlpha.toValue = 0.4
        changeAlpha.duration = 0.8
        changeAlpha.repeatCount = Float.infinity
        changeAlpha.autoreverses = true
        view.layer.addAnimation(changeAlpha, forKey: "ChangeAlpha")
        view.layer.speed = 1.0;
    }
   
}
