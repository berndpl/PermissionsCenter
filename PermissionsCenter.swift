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
PermissionsCenter.shared.addPermission(PermissionType.LocalNotifications)
PermissionsCenter.shared.addPermission(PermissionType.LocationServiceAlways)
PermissionsCenter.shared.checkAllPermissions()
PermissionsCenter.shared.actOnNextMissingPermission()
println("<Permissions> All Granted? \(PermissionsCenter.shared.allGranted())")
*/

import UIKit

class PermissionsCenter: NSObject {
    
    let logSwitch:Bool = false
    
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
        Logger.log(logSwitch, logMessage: "[Permissions] PermissionsCenter Init")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func resetState() {
        permissionsMissing.removeAllObjects()
        permissionsMissing.addObjectsFromArray(permissions)
    }
    
    func setup(backgroundView:UIView) {
        self.backgroundView = backgroundView
        permissionButton = PermissionButton.buttonWithType(UIButtonType.System) as? PermissionButton
        permissionButton?.setup(backgroundView)
    }
    
    func addPermission(permissionType:PermissionType) {
        Logger.log(logSwitch, logMessage: "[Permissions] Adding (\(Permission.typeAsString(permissionType)))")
        var permissionToAdd:Permission?
        
        if isTypeInArray(permissionType, permissionsArray: permissions) == false {
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
            case .Reminders:
                permissionToAdd = PermissionReminders(
                    type: PermissionType.Reminders,
                    buttonText: "Allow Access to Reminders",
                    buttonTextSettings: "Enable Access to Reminders")
            default: println("Unrecognized Permission Type \(permissionType)")
            }   
            if permissionToAdd != nil {
                permissions.addObject(permissionToAdd!)
                permissionsMissing.addObject(permissionToAdd!)
            }
        } else {
            println("[Permissions] Already added")
        }
    }
    
    func check() {
        permissionButton?.hide()
        checkAllPermissions()
        actOnNextMissingPermission()
    }
    
    func checkAllPermissions() {
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

    func isTypeInArray(permissionType:PermissionType,permissionsArray:NSMutableArray)->Bool {
        for item:AnyObject in permissionsArray {
            let permissionItem = item as Permission
            if permissionItem.type == permissionType {
                return true
            }
        }
        return false
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
        Logger.log(logSwitch, logMessage: "[Permissions] Unrecognized PermissionType to check: \(permissionType)")
        return false
    }
    
    func actOnNextMissingPermission() {
        Logger.log(logSwitch, logMessage: "[Permissions] Check (\(permissionsMissing.count))")
        if permissionsMissing.count > 0 {
            let permission = permissionsMissing.lastObject as Permission
            actOnPermissionStatus(permission)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("defaultsDidChange", object: nil)
        }
    }
    
    func actOnPermissionStatus(permission:Permission) {
        
        Logger.log(logSwitch, logMessage: "[Permissions] Check for \(permission.simpleDescription())")
        Logger.log(logSwitch, logMessage: "[Permissions] Request \(permissionOfType(permission.type)?.simpleDescription())")
        

            if permission.granted == nil {
                if permission.requested == false {
                    permissionButton?.show(permission.buttonText, target: permission, actionSelector: "request")
                } else {
                    permissionButton?.show(permission.buttonText, target: permission, actionSelector: "requestFallback")
                }
            } else {
                if permission.granted == false { // REQUESTED + NOT GRANTED -> Request
                    if permission.requested == false {
                        Logger.log(logSwitch, logMessage: "[Permissions] Request")
                        permissionButton?.show(permission.buttonText, target:permission, actionSelector: "request")
                    }
                    if permission.requested == true {
                        Logger.log(logSwitch, logMessage: "[Permissions] Settings")
                        permissionButton?.show(permission.buttonTextSettings, target:permission, actionSelector: "requestFallback")
                    }
                } else {
                    permissionButton?.hide()
                }
            }
        
        
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
        Logger.log(logSwitch, logMessage: "[Permissions] ======= Check - Permissions \(permissions.count) Missing \(permissionsMissing.count) =======")
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
        Logger.log(logSwitch, logMessage: "[Permissions] Updated Local Notifications Settings: \(notificationSettings)")
        
        if permissionsMissing.count > 0 {
            if (permissionsMissing.lastObject as Permission).type == PermissionType.LocalNotifications {
                check()
            }
        }
    }
    
    func willEnterForeground() {
        Logger.log(logSwitch, logMessage: "[Permissions] ======= FOREGROUND Permissions \(permissions.count) Missing \(permissionsMissing.count) =======")
        
        check()
    }

    
}
