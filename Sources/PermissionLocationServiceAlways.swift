//
//  PermissionLocalNotification.swift
//  Nexts
//
//  Created by Bernd Plontsch on 22/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit
import CoreLocation

class PermissionLocationServiceAlways: NSObject, CLLocationManagerDelegate {

    var locationManager:CLLocationManager = CLLocationManager()
    
    //CHECK
    //REQUEST
    
    class var shared : PermissionLocationServiceAlways {
        struct Singleton {
            static let instance = PermissionLocationServiceAlways()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("Location Manager - did change authorizatio state")
        PermissionsCenter.shared.permissionsButton?.hide()
        PermissionLocationServiceAlways.check()
        PermissionsCenter.shared.actOnNextMissingPermission()
    }
    
    class func check()->Bool {
        
        var currentStatus:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        var requiredStatus:CLAuthorizationStatus = CLAuthorizationStatus.Authorized

        var permission:Permission? = PermissionsCenter.shared.permissionOfType(PermissionType.LocationServiceAlways)
        
        if currentStatus != requiredStatus {
            switch currentStatus {
            case CLAuthorizationStatus.NotDetermined:
                println("\t [LocationServiceAlways] Check - NotDetermined")
                return false
            case CLAuthorizationStatus.Denied:
                println("\t [LocationServiceAlways] Check - Denied")
                permission?.requested = true
                permission?.granted = false
                return false
            default:
                println("\t [LocationServiceAlways]  - Missing Info - Default")
                return false
            }
        } else {
            permission?.requested = true
            permission?.granted = true
            PermissionsCenter.shared.permissionsMissing.removeObject(permission!) //REMOVE GRANTED
            return true
        }
    }
    
    func request(){
        println("\t [LocationServiceAlways] Request")
        locationManager.requestAlwaysAuthorization()
        PermissionsCenter.shared.permissionsButton?.hide()
    }
    
    class func requestFallback(){
        println("\t [LocationServiceAlways] Request Fallback")
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
}
