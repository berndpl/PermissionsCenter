//
//  PermissionLocalNotification.swift
//  Nexts
//
//  Created by Bernd Plontsch on 22/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class PermissionLocalNotification: NSObject {

    //CHECK
    //REQUEST
    
    class func check()->Bool{
        var currentStatus = UIApplication.sharedApplication().currentUserNotificationSettings()
        var requiredStatus:UIUserNotificationType = UIUserNotificationType.Alert

        var permission:Permission? = PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)

        if currentStatus.types == requiredStatus {
            //println("\t [LocalNotification] Granted \(currentStatus.types)")
            //println ("\(permission!.simpleDescription())")
            PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)?.granted = true
            PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)?.requested = true
            PermissionsCenter.shared.permissionsMissing.removeObject(permission!) //REMOVE GRANTED
            return true
        } else {
            PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)?.granted = false
            PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)?.requested = true
            //println ("\t [LocalNotification] Missing \(currentStatus.types)")
            //println ("\(permission!.simpleDescription())")
            return false
        }
    }
    
    class func request(){
        println("\t [LocalNotification] Request")
        var notificationSetting:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: (UIUserNotificationType.Alert), categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSetting)
        PermissionsCenter.shared.permissionsButton?.hide()
    }
    
    class func requestFallback() {
        println("\t [LocalNotification] Request Fallback")
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
}
