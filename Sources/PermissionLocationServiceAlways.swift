//
//  PermissionLocalNotification.swift
//  Nexts
//
//  Created by Bernd Plontsch on 22/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit
import CoreLocation

class PermissionLocationServiceAlways: Permission, CLLocationManagerDelegate {

    let logSwitch:Bool = false
    
    var locationManager:CLLocationManager = CLLocationManager()
        
    override init() {
        super.init()
        locationManager.delegate = self
        checkForPlistEntry("NSLocationAlwaysUsageDescription")
    }
    
    func checkForPlistEntry(entryString:NSString)->Bool{
        var entry:NSString? = NSBundle.mainBundle().objectForInfoDictionaryKey(entryString) as? NSString
        if entry != nil {
            println("[LocationServiceAlways] Ok. Plist Entry exists \(entryString)")
            return true
        } else {
            fatalError("[LocationServiceAlways] Required Plist Entry Missing (\(entryString))")
            return false
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        Logger.log(logSwitch, logMessage: "[LocationServiceAlways] Did change authorization state")
        var currentStatus:CLAuthorizationStatus = status
        var requiredStatus:CLAuthorizationStatus = CLAuthorizationStatus.Authorized
        PermissionsCenter.shared.check()
    }
    
    override func check()->Bool {
        
        var currentStatus:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        //var currentStatus:CLAuthorizationStatus = CLAuthorizationStatus.NotDetermined
        var requiredStatus:CLAuthorizationStatus = CLAuthorizationStatus.Authorized

        var permission:Permission? = PermissionsCenter.shared.permissionOfType(PermissionType.LocationServiceAlways)
        
        if currentStatus != requiredStatus {
            switch currentStatus {
            case CLAuthorizationStatus.NotDetermined:
                Logger.log(logSwitch, logMessage: "\t [LocationServiceAlways] Check - NotDetermined")
                permission?.requested = false
                //permission?.granted = nil
                return false
            case CLAuthorizationStatus.Denied:
                Logger.log(logSwitch, logMessage: "\t [LocationServiceAlways] Check - Denied")
                permission?.requested = true
                permission?.granted = false
                return false
            default:
                Logger.log(logSwitch, logMessage: "\t [LocationServiceAlways]  - Missing Info - Default")
                return false
            }
        } else {
            permission?.requested = true
            permission?.granted = true
            PermissionsCenter.shared.permissionsMissing.removeObject(permission!) //REMOVE GRANTED
            return true
        }
    }
    
    override func request(){
        PermissionsCenter.shared.permissionButton?.pulseAnimation()
        var permission:Permission? = PermissionsCenter.shared.permissionOfType(PermissionType.LocationServiceAlways)
        permission?.requested = true
        Logger.log(logSwitch, logMessage: "\t [LocationServiceAlways] Request")
        locationManager.requestAlwaysAuthorization()
    }
    
    override func requestFallback(){
        Logger.log(logSwitch, logMessage: "\t [LocationServiceAlways] Request Fallback")
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    
    func stringForCLAuthorizationStatus(status:CLAuthorizationStatus)->NSString{
        var authorizationStatus:NSString = "not set"
        switch status {
        case .Authorized: authorizationStatus = "Authorized"
        case .AuthorizedWhenInUse: authorizationStatus = "Authorized When In Use"
        case .Denied: authorizationStatus = "Denied"
        case .NotDetermined: authorizationStatus = "Not Determined"
        case .Restricted: authorizationStatus = "Restricted"
        default: authorizationStatus = "no"
        }
        return authorizationStatus
    }
    
}
