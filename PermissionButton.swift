//
//  PermissionButton.swift
//  Nexts
//
//  Created by Bernd Plontsch on 21/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

protocol PermissionButtonDelegate {
}

class PermissionButton: UIButton {

    let styleBorder:Bool = false
    let styleBorderWidth:CGFloat = 4.0
    let styleFont:UIFont = UIFont(name: "AvenirNext-Heavy", size: 18.0)!
    let styleBackgroundColor:UIColor = UIColor.blackColor()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //var buttonActivity : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
    
    var delegate:PermissionButtonDelegate?
    
    var permission:Permission?
    
    func setup(backgroundView:UIView,permission:Permission, delegate:PermissionButtonDelegate) {
        
        self.delegate = delegate
        self.permission = permission
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
            self.hidden = true
            stopPulseAnimation()
    }
    
    func show(buttonTitle:NSString,target:AnyObject,actionSelector:NSString) {
            self.userInteractionEnabled = true
            self.setTitle(buttonTitle, forState: UIControlState.Normal)
            self.addTarget(target, action:Selector(actionSelector), forControlEvents: UIControlEvents.TouchUpInside)
            self.hidden = false
    }
    
    func pulseAnimation() {
        HelperAnimation.pulse(self)
        self.userInteractionEnabled = false
    }

    func stopPulseAnimation() {
        self.layer.removeAllAnimations()
        self.userInteractionEnabled = true
    }

    
}
