//
//  PermissionLocalNotification.swift
//  Nexts
//
//  Created by Bernd Plontsch on 22/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class PermissionLocalNotification: Permission {
    
    let logSwitch:Bool = true
    
    override init() {
        super.init()
        checkForRequiredImplementation()
    }
    
    func checkForRequiredImplementation()->Bool {
        var implemented:Bool? = UIApplication.sharedApplication().delegate?.respondsToSelector("application:didRegisterUserNotificationSettings:")
        if implemented == true {
            Logger.log(logSwitch, logMessage: "[LocalNotifications] Ok. Delegate in App Delegate implemented")
            return true
        } else {
            let missingImplementation = "func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)"
            let missingImplementationDetail = "PermissionsCenter.shared.updateState(PermissionType.LocalNotifications,notificationSettings: notificationSettings)"
            fatalError("Missing Implementation in App Delegate: call (\(missingImplementationDetail)) in (\(missingImplementation))")
            return false
        }
    }
    
    override func check()->Bool{
        var currentStatus:UIUserNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings()
        var requiredStatus:UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert
        var permission:Permission? = PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)
        
        if currentStatus.types == requiredStatus {
            PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)?.granted = true
            PermissionsCenter.shared.permissionsMissing.removeObject(permission!) //REMOVE GRANTED
            Logger.log(logSwitch, logMessage: "[LocalNotifications] Granted")
            return true
        } else {
            PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)?.granted = false
            Logger.log(logSwitch, logMessage: "[LocalNotifications] Denied")
            return false
        }
    }
    
    override func request(){
        PermissionsCenter.shared.permissionButton?.pulseAnimation()
        var permission:Permission? = PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)
        permission?.requested = true
        var types:UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert
        var settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        Logger.log(logSwitch, logMessage: "[LocalNotifications] Request")
    }
    
    override func requestFallback() {
        Logger.log(logSwitch, logMessage: "[LocalNotification] Request Fallback")
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
}
