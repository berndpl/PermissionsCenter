PermissionsCenter
=================

An approach to present sequential permission requests on iOS8.

## Supported Permission Types

* **LocalNotifications** - Required: Helper function in AppDelegate required for callback
* **LocationServicesAlways** - Required:  NSLocationAlwaysUsageDescription entry in plist
* **Calendar**
* **Reminders**

## Usage

1. Add Helper functions if required – see **Supported Permission Types**

2. Setup PermissionsCenter with background view for Request Button

        PermissionsCenter.shared.setup(headerView)

3. Add Permissions to monitor

        PermissionsCenter.shared.addPermission(PermissionType.LocalNotifications)
        PermissionsCenter.shared.addPermission(PermissionType.LocationServiceAlways)
        PermissionsCenter.shared.addPermission(PermissionType.Calendar)
	    PermissionsCenter.shared.addPermission(PermissionType.Reminders)
                

4. Check Permissions

	    PermissionsCenter.shared.check()
                
## Interface

A button centered on the background view. When there is an ongoing permission request it pulses.