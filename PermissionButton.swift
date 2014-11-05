//
//  PermissionButton.swift
//  Nexts
//
//  Created by Bernd Plontsch on 21/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class PermissionButton: UIButton {

    let styleBorder:Bool = false
    let styleBorderWidth:CGFloat = 4.0
    let styleFont:UIFont = UIFont(name: "AvenirNext-Heavy", size: 18.0)!
    let styleBackgroundColor:UIColor = UIColor.blackColor()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(backgroundView:UIView) {

        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //STYLE BUTTON
        
        if styleBorder == true {
            layer.borderWidth = styleBorderWidth
            layer.cornerRadius = 15.0
            layer.borderColor = UIColor.lightGrayColor().CGColor
            backgroundColor = styleBackgroundColor
        }
        titleLabel?.font = styleFont
        setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15)
        
        //CENTER BUTTON
        backgroundView.addSubview(self)
        backgroundView.bringSubviewToFront(self)
        var viewsDictionary:NSDictionary  = ["permissionsButton":self]
        
        backgroundView.addConstraint(NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: backgroundView,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: 0))
        
        backgroundView.addConstraint(NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: backgroundView,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: 0))
        
        backgroundView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[permissionsButton(50)]", options: nil, metrics: nil, views: viewsDictionary))
        
        self.hidden = true
    }
    
    func hide() {
        self.stopPulseAnimation()
        self.hidden = true
    }
    
    func show(buttonTitle:NSString,target:AnyObject,actionSelector:NSString) {
        self.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        self.userInteractionEnabled = true
        self.setTitle(buttonTitle, forState: UIControlState.Normal)
        self.addTarget(target, action:Selector(actionSelector), forControlEvents: UIControlEvents.TouchUpInside)
        self.hidden = false
    }
    
    func pulseAnimation() {
        println("--PULSE")
        self.layer.removeAllAnimations()
        HelperAnimation.pulse(self)
        self.userInteractionEnabled = false
    }

    func stopPulseAnimation() {
        println("--PULSE stop")
        self.layer.removeAllAnimations()
        self.userInteractionEnabled = true
    }

    
}
