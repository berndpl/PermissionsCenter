//
//  Permission.swift
//  Nexts
//
//  Created by Bernd Plontsch on 20/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

enum PermissionType {
    case LocationServiceAlways
    case LocalNotifications
    case Calendar
    case Reminders
    case None
}

class Permission: NSObject {
    
    var showRequestWithoutButton:Bool = false
    var granted:Bool?
    var requested:Bool = false
    var type:PermissionType = PermissionType.None
    var buttonText:NSString = ""
    var buttonTextSettings:NSString = ""
    var buttonTargetSelector:NSString = ""
    var buttonTargetSelectorSettings:NSString = ""
    
    convenience init(type:PermissionType,buttonText:NSString,buttonTextSettings:NSString,buttonTargetSelector:NSString,buttonTargetSelectorSettings:NSString) {
        self.init()
        self.type = type
        self.buttonText = buttonText
        self.buttonTextSettings = buttonTextSettings
        self.buttonTargetSelector = buttonTargetSelector
        self.buttonTargetSelectorSettings = buttonTargetSelectorSettings
        if type == PermissionType.LocalNotifications {
            showRequestWithoutButton = true
        }
    }
    
    func check()->Bool {
        println("[Permission] not implemented: check")
        return false
    }
    
    func request() {
        println("[Permission] not implemented: request")
    }
    
    func requestFallback(){
        println("[Permission] not implemented: requestFallback")
    }
    
    func simpleDescription()->NSString{
        return ("\t [Permission] \(Permission.typeAsString(type)) \t Requested (\(requested)) Granted (\(granted))")
    }
    
    class func typeAsString(type:PermissionType)->NSString {
        switch type {
        case .LocalNotifications: return "LocalNotifications"
        case .LocationServiceAlways: return "LocationServiceAlways"
        case .Calendar: return "Calendar"
        case .Reminders: return "Reminders"
        default: return "[Permission] Type Missing"
        }
    }
    
    
}
