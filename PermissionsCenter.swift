//
//  Permissions.swift
//  Nexts
//
//  Created by Bernd Plontsch on 20/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

// Usage

// For Local Notification - Add to App Delegate

/*
func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    PermissionsCenter.shared.updateState(PermissionType.LocalNotifications,notificationSettings: notificationSettings)
}
*/

// Setup

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
    
    let logSwitch:Bool = true
    
    var permissions:NSMutableArray = NSMutableArray()
    var permissionsMissing:NSMutableArray = NSMutableArray()
    
    var backgroundView:UIView?
    var permissionButton:PermissionButton?
    
    class var shared : PermissionsCenter {
        struct Singleton {
            static let instance = PermissionsCenter()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        Logger.log(logSwitch, logMessage: "[PermissionsCenter] Init")
        permissionButton = PermissionButton.buttonWithType(UIButtonType.System) as? PermissionButton
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func resetState() {
        permissionsMissing.removeAllObjects()
        permissionsMissing.addObjectsFromArray(permissions)
    }
    
    func setup(backgroundView:UIView) {
        self.backgroundView = backgroundView
    }
    
    func addPermission(permissionType:PermissionType) {
        Logger.log(logSwitch, logMessage: "[Permissions] Adding (\(Permission.typeAsString(permissionType)))")
        var permissionToAdd:Permission?
        
        switch permissionType {
        case .LocalNotifications:
            permissionToAdd = PermissionLocalNotification(
                type: PermissionType.LocalNotifications,
                buttonText: "Allow Notifications",
                buttonTextSettings: "Enable Notifications")
        case .LocationServiceAlways:
            permissionToAdd = PermissionLocationServiceAlways(
                type: PermissionType.LocationServiceAlways,
                buttonText: "Allow Ranging of iBeacons",
                buttonTextSettings: "Enable Location Services")
        case .Calendar:
            permissionToAdd = PermissionCalendar(
                type: PermissionType.Calendar,
                buttonText: "Allow Calendar Access",
                buttonTextSettings: "Enable Calendar Access")
        default: println("Unrecognized Permission Type \(permissionType)")
        }
        
        if permissionToAdd != nil {
            permissions.addObject(permissionToAdd!)
            permissionsMissing.addObject(permissionToAdd!)
        }
    }
    
    func checkAllPermissions () {
        Logger.log(logSwitch, logMessage: "[Permissions] Check All")
        for item:AnyObject in permissions {
            var permission = item as Permission
            Logger.log(logSwitch, logMessage: "-- \(Permission.typeAsString(permission.type)) > \(check(permission.type)) G (\(permission.granted)) R (\(permission.requested))")
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
        for item:AnyObject in permissions {
          var permission = item as Permission
            if permission.type == permissionType {
                return permission.check()
            }
        }
        Logger.log(logSwitch, logMessage: "Unrecognized Permission Type to check: \(permissionType)")
        return false
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

        permissionButton?.hide()
        permissionButton?.setup(backgroundView!, permission: permission, delegate: self)
        
        Logger.log(logSwitch, logMessage: "[Permissions] Check For: \(permission.simpleDescription())")
        Logger.log(logSwitch, logMessage: "request \(permissionOfType(permission.type)?.simpleDescription())")
        
        if permission.granted == nil {
            if backgroundView != nil {
                if permission.requested == false {
                    permissionButton?.show(permission.buttonText, target: permission, actionSelector: "request")
                } else {
                    permissionButton?.show(permission.buttonText, target: permission, actionSelector: "requestFallback")
                }
            }
        } else {
            if permission.granted == false { // REQUESTED + NOT GRANTED -> Request
                    if permission.requested == false {
                    if backgroundView != nil {
                        Logger.log(logSwitch, logMessage: "REQUEST")
                        permissionButton?.show(permission.buttonText, target:permission, actionSelector: "request")
                    }
                }
                if permission.requested == true {
                    if backgroundView != nil {
                        Logger.log(logSwitch, logMessage: "SETTINGS")
                        permissionButton?.show(permission.buttonTextSettings, target:permission, actionSelector: "requestFallback")
                    }
                }
            } else {

                permissionButton?.hide()
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
        Logger.log(logSwitch, logMessage: "======= [Permissions] Check - Permissions \(permissions.count) Missing \(permissionsMissing.count)=======")
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
    
    func updateState(type:PermissionType,notificationSettings: UIUserNotificationSettings){
        Logger.log(logSwitch, logMessage: "Update localNotificationSettings: \(notificationSettings)")
        permissionButton?.stopPulseAnimation()
        // mark: to do check types more specifically than nil
        if notificationSettings.types == nil {
            println ("NIL")
            var permission:Permission? = permissionOfType(PermissionType.LocalNotifications)
            println ("set \(permission?.simpleDescription())")
            if permission != nil {
                permission!.requested = true
                            println ("set \(permission?.simpleDescription())")
                actOnNextMissingPermission()
            }
        } 
    }
    
    func willEnterForeground() {
        Logger.log(logSwitch, logMessage: "======= FOREGROUND Permissions \(permissions.count) Missing \(permissionsMissing.count)=======")
        permissionButton?.hide()
        PermissionsCenter.shared.checkAllPermissions()
        PermissionsCenter.shared.actOnNextMissingPermission()
    }

    
}
