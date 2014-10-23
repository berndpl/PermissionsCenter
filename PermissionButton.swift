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

    var delegate:PermissionButtonDelegate?
    
    var permission:Permission?
    
    func setup(interfaceView:UIView,permission:Permission, delegate:PermissionButtonDelegate) {
        
        self.delegate = delegate
        self.permission = permission
        setTranslatesAutoresizingMaskIntoConstraints(false)
        layer.cornerRadius = 15.0
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.borderWidth = Settings.styleLineWidth()/2.0
        titleLabel?.font = UIFont.defaultFontWithSize(Settings.styleCalculatedLineSize(15.0, referenceView: interfaceView))
        setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15)
        
        interfaceView.addSubview(self)
        interfaceView.bringSubviewToFront(self)
        backgroundColor = UIColor.nextsDarkColorWithAlpha(0.5)
        var viewsDictionary:NSDictionary  = ["permissionsButton":self]
        
        interfaceView.addConstraint(NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: interfaceView,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: 0))
        
        interfaceView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-50-[permissionsButton(50)]", options: nil, metrics: nil, views: viewsDictionary))
        
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
