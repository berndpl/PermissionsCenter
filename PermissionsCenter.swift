//
//  Permissions.swift
//  Nexts
//
//  Created by Bernd Plontsch on 20/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

// Usage

/*
PermissionsCenter.shared.setup(view)
PermissionsCenter.shared.addPermission(PermissionType.LocalNotifications) //Local Notifaciton last/first to show, because no callback
PermissionsCenter.shared.addPermission(PermissionType.LocationServiceAlways)
PermissionsCenter.shared.checkAllPermissions()
PermissionsCenter.shared.actOnNextMissingPermission()
println("<Permissions> All Granted? \(PermissionsCenter.shared.allGranted())")
*/

import UIKit

class PermissionsCenter: NSObject, PermissionButtonDelegate {
    
    let logSwitch:Bool = false
    
    var viewForButton:UIView?
    
    var permissions:NSMutableArray = NSMutableArray()
    var permissionsMissing:NSMutableArray = NSMutableArray()
    
    var permissionsButton:PermissionButton?
    
    class var shared : PermissionsCenter {
        struct Singleton {
            static let instance = PermissionsCenter()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        Logger.log(logSwitch, logMessage: "[PermissionsCenter] Init")
        //BUTTON
        permissionsButton = PermissionButton.buttonWithType(UIButtonType.System) as? PermissionButton

        //PERMISSIONS
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func resetState() {
        permissionsMissing.removeAllObjects()
        permissionsMissing.addObjectsFromArray(permissions)
    }
    
    func setup(viewForButton:UIView) {
        self.viewForButton = viewForButton
    }
    
    func addPermission(permissionType:PermissionType) {
        Logger.log(logSwitch, logMessage: "[Permissions] Adding (\(Permission.typeAsString(permissionType)))")
        var permissionToAdd:Permission?
        
        switch permissionType {
        case .LocalNotifications:
            permissionToAdd = Permission(
                type: PermissionType.LocalNotifications,
                buttonText: "Allow Notifications",
                buttonTextSettings: "Enable Notifications",
                buttonTargetSelector: "requestLocalNotification",
                buttonTargetSelectorSettings: "requestFallbackLocalNotification")
        case .LocationServiceAlways:
            permissionToAdd = Permission(
                type: PermissionType.LocationServiceAlways,
                buttonText: "Allow Ranging of iBeacons",
                buttonTextSettings: "Enable Location Services",
                buttonTargetSelector: "requestLocationServiceAlways",
                buttonTargetSelectorSettings: "requestFallbackLocationServiceAlways")
        default: println("Unrecognized Permission Type \(permissionType)")
        }
        
        if permissionToAdd != nil {
            permissions.addObject(permissionToAdd!)
            permissionsMissing.addObject(permissionToAdd!)
        }
        
        //check(permissionType)
    }
    
    func requestLocalNotification() {
        simpleDescription()
        PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)?.requested = true
                simpleDescription()
        PermissionLocalNotification.shared.request()
        //permissionsButton?.hide()
        //check()
    }
    
    func requestFallbackLocalNotification() {
        UIApplication.sharedApplication().openURL(NSURL(fileURLWithPath: UIApplicationOpenSettingsURLString)!)
        PermissionLocalNotification.shared.requestFallback()
        //permissionsButton?.hide()
        //check()
    }
    
    func requestLocationServiceAlways(){
        check(PermissionType.LocationServiceAlways)
        PermissionLocationServiceAlways.shared.request()
    }
    
    func requestFallbackLocationServiceAlways(){
        PermissionLocationServiceAlways.requestFallback()
    }
    
    func checkAllPermissions () {
        Logger.log(logSwitch, logMessage: "[Permissions] Check All")
        for item:AnyObject in permissions {
            var permission = item as Permission
            println("-- \(Permission.typeAsString(permission.type)) > \(check(permission.type)) G (\(permission.granted)) R (\(permission.requested))")
            if check(permission.type) == false {
                if isInArray(permission,permissionsArray: permissionsMissing) == false {
                    permissionsMissing.addObject(permission)
                }
            } else {
                permissionsMissing.removeObject(permission)
            }
        }
        simpleDescription()
    }
    
    func isInArray(permission:Permission,permissionsArray:NSMutableArray)->Bool {
        for item:AnyObject in permissionsArray {
            let permissionItem = item as Permission
            if permissionItem.type == permission.type {
                return true
            }
        }
        return false
    }
    
    func check(permissionType:PermissionType)->Bool{
        switch permissionType {
        case .LocalNotifications:
            return PermissionLocalNotification.shared.check()
        case .LocationServiceAlways:
            return PermissionLocationServiceAlways.check()
        default: println("Unrecognized Check Permission Type \(permissionType)")
            return false
        }
    }
    
    func actOnNextMissingPermission() {
        //println("[Permissions] Check (\(permissionsMissing.count))")
        if permissionsMissing.count > 0 {
            let permission = permissionsMissing.lastObject as Permission
            check(permission.type)
            actOnPermissionStatus(permission)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("defaultsDidChange", object: nil)
        }
    }
    
    func actOnPermissionStatus(permission:Permission)->Bool {
        
        if permissionsMissing.count == 0 {
            return true
        }
        
        check(permission.type)
        
        permissionsButton?.setup(viewForButton!, permission: permission, delegate: self)
        
        Logger.log(logSwitch, logMessage: "[Permissions] Check For: \(permission.simpleDescription())")
        
        if permission.granted == nil {
            //self.viewForButton?.backgroundColor = UIColor.orangeColor()
            if viewForButton != nil {
                permissionsButton?.show(permission.buttonText, target: self, actionSelector: permission.buttonTargetSelector)
            }
        } else {
            if permission.granted == false { // REQUESTED + NOT GRANTED -> Request
                if permission.requested == false {
                    //self.viewForButton?.backgroundColor = UIColor.orangeColor()
                    if viewForButton != nil {
                        Logger.log(logSwitch, logMessage: "REQUEST")
                        permissionsButton?.show(permission.buttonText, target: self, actionSelector: permission.buttonTargetSelector)
                    }
                }
                if permission.requested == true {
                    //self.viewForButton = UIColor.purpleColor()
                    if viewForButton != nil {
                        Logger.log(logSwitch, logMessage: "SETTINGS")
                        permissionsButton?.show(permission.buttonTextSettings, target: self, actionSelector: permission.buttonTargetSelectorSettings)
                    }
                }
            } else {
                permissionsButton?.hide()
            }
        }
        
        return false
    }
    
    //MARK: State
    
    func permissionOfType(type:PermissionType)->Permission? {
        for item:AnyObject in permissions {
            let permission = item as Permission
            if permission.type == type {
                return permission
            }
        }
        return nil
    }
    
    func simpleDescription() {
        println("======= [Permissions] Check - Permissions \(permissions.count) Missing \(permissionsMissing.count)=======")
        for item:AnyObject in permissionsMissing {
            let permission = item as Permission
            Logger.log(logSwitch, logMessage: "\t [Missing] \(permission.simpleDescription())")
        }
        
    }
    
    func allGranted()->Bool{
        if permissionsMissing.count > 0 {
            Logger.log(logSwitch, logMessage: "[Permissions] All Granted: NO")
            return false
        } else {
            Logger.log(logSwitch, logMessage: "[Permissions] All Granted: YES")
            return true
        }
    }
    
    func willEnterForeground() {
        Logger.log(logSwitch, logMessage: "======= FOREGROUND Permissions \(permissions.count) Missing \(permissionsMissing.count)=======")
        permissionsButton?.hide()
        PermissionsCenter.shared.checkAllPermissions()
        PermissionsCenter.shared.actOnNextMissingPermission()
        //resetState()
        //checkNextMissingPermission()
    }

    
}
