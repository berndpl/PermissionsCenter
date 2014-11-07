//
//  PermissionLocalNotification.swift
//  Nexts
//
//  Created by Bernd Plontsch on 22/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class PermissionLocalNotification: Permission {
    
    let logSwitch:Bool = false
    
    override init() {
        super.init()
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
