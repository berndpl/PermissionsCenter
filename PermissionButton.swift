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
        
//        var buttonActivity:UIActivityIndicatorView = UIActivityIndicatorView()
//        buttonActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        backgroundView.addSubview(buttonActivity)
//        buttonActivity.startAnimating()

     //   var activityButtonConstraint:NSLayoutConstraint = NSLayoutConstraint(
        
//        NSLayoutConstraint *myConstraint =[NSLayoutConstraint
//            constraintWithItem:mylabel
//            attribute:NSLayoutAttributeCenterY
//            relatedBy:NSLayoutRelationEqual
//            toItem:superview
//            attribute:NSLayoutAttributeCenterY
//            multiplier:1.0
//            constant:0];
//        
//        [superview addConstraint:myConstraint];
//        
//        myConstraint =[NSLayoutConstraint
//            constraintWithItem:mylabel
//            attribute:NSLayoutAttributeCenterX
//            relatedBy:NSLayoutRelationEqual
//            toItem:superview
//            attribute:NSLayoutAttributeCenterX
//            multiplier:1.0
//            constant:0];
//        
//        [superview addConstraint:myConstraint];
        
        self.hidden = true
    }
    
    func hide() {
            self.hidden = true
    }
    
    func show(buttonTitle:NSString,target:AnyObject,actionSelector:NSString) {
            self.setTitle(buttonTitle, forState: UIControlState.Normal)
            self.addTarget(target, action:Selector(actionSelector), forControlEvents: UIControlEvents.TouchUpInside)
            self.hidden = false
    }
    
    func pulseAnimation() {
        HelperAnimation.pulse(self)
    }

    func stopPulseAnimation() {
        self.layer.removeAllAnimations()
    }

    
}
