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
    
    var delegate:PermissionButtonDelegate?
    
    var permission:Permission?
    
    func setup(interfaceView:UIView,permission:Permission, delegate:PermissionButtonDelegate) {
        
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
        
        interfaceView.addSubview(self)
        interfaceView.bringSubviewToFront(self)
        var viewsDictionary:NSDictionary  = ["permissionsButton":self]
        
        interfaceView.addConstraint(NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: interfaceView,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: 0))
        
        interfaceView.addConstraint(NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: interfaceView,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: 0))
        
        interfaceView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[permissionsButton(50)]", options: nil, metrics: nil, views: viewsDictionary))
        
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
    
}
