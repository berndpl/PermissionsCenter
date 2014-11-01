//
//  PermissionLocalNotification.swift
//  Nexts
//
//  Created by Bernd Plontsch on 22/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class PermissionLocalNotification: NSObject {
    
    class var shared : PermissionLocalNotification {
        struct Singleton {
            static let instance = PermissionLocalNotification()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
    }
    
    func check()->Bool{
        var currentStatus:UIUserNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings()
        var requiredStatus:UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert

        var permission:Permission? = PermissionsCenter.shared.permissionOfType(PermissionType.LocalNotifications)
        if permission?.showRequestWithoutButton == true && permission?.granted == false {
            request()
        }
        
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
    
    func request(){
        println("\t [LocalNotification] Request")
        var types:UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert
        var settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        PermissionsCenter.shared.permissionsButton?.hide()
    }
    
    func requestFallback() {
        println("\t [LocalNotification] Request Fallback")
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
}
