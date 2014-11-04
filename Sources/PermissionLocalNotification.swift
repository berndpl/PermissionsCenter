//
//  PermissionLocalNotification.swift
//  Nexts
//
//  Created by Bernd Plontsch on 22/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class PermissionLocalNotification: Permission {
        
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
            return true
        } else {
            PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)?.granted = false
            return false
        }
    }
    
    override func request(){
        println("\t [LocalNotification] Request")
        var types:UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert
        var settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        PermissionsCenter.shared.permissionButton?.pulseAnimation()
    }
    
    override func requestFallback() {
        println("\t [LocalNotification] Request Fallback")
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
}
