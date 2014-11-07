//
//  PermissionLocalNotification.swift
//  Nexts
//
//  Created by Bernd Plontsch on 22/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit
import EventKit

class PermissionCalendar: Permission {
    
    let logSwitch:Bool = false
    
    var eventStore:EKEventStore = EKEventStore()
    
    override init() {
        super.init()
    }
    
    override func check()->Bool {
        
        var currentStatus:EKAuthorizationStatus = EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent)
        var requiredStatus:EKAuthorizationStatus = EKAuthorizationStatus.Authorized

        var permission:Permission? = PermissionsCenter.shared.permissionOfType(PermissionType.Calendar)
        
        if currentStatus != requiredStatus {
            switch currentStatus {
            case .Authorized:
                Logger.log(logSwitch, logMessage: "[Calendar] Authorized - Should not happen. Here.")
                permission?.requested = true
                permission?.granted = true
                return true
            case .NotDetermined:
                Logger.log(logSwitch, logMessage: "[Calendar] NotDetermined")
                permission?.requested = false
                permission?.granted = nil
            case .Restricted:
                Logger.log(logSwitch, logMessage: "[Calendar] Restricted")
                permission?.requested = true
                permission?.granted = false
            case .Denied:
                Logger.log(logSwitch, logMessage: "[Calendar] Denied")
                permission?.requested = true
                permission?.granted = false
            default:
                Logger.log(logSwitch, logMessage: "[Calendar] Default - Should Not Happen")
                permission?.requested = true
                permission?.granted = false
            }
            return false
        } else {
            permission?.requested = true
            permission?.granted = true
            PermissionsCenter.shared.permissionsMissing.removeObject(permission!) //REMOVE GRANTED
            return true
        }
    }
    
    override func request(){
        println("\t [Calendar] Request")
        PermissionsCenter.shared.permissionButton?.pulseAnimation()
        self.eventStore.requestAccessToEntityType(EKEntityTypeEvent) {
            (granted: Bool, err: NSError!) in
            dispatch_async(dispatch_get_main_queue()) {
                println("[Calendar] Request Result. Granted? \(granted)")
                var permission:Permission? = PermissionsCenter.shared.permissionOfType(PermissionType.Calendar)
                permission?.granted = granted
                PermissionsCenter.shared.check()
            }
        }
    }
    
    override func requestFallback(){
        println("\t [Calendar] Request Fallback")
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func stringForEKAuthorizationStatus(status:EKAuthorizationStatus)->NSString{
        var authorizationStatus:NSString = "not set"
        switch status {
        case .Authorized: authorizationStatus = "Authorized"
        case .Denied: authorizationStatus = "Denied"
        case .NotDetermined: authorizationStatus = "Not Determined"
        case .Restricted: authorizationStatus = "Restricted"
        default: authorizationStatus = "no"
        }
        return authorizationStatus
    }
    
}
