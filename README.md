PermissionsCenter
=================

A unified approach on implementing permission requests on iOS8

## Supported

* **LocalNotifications** - support limited due to missing callback/delegate methods
* **LocationServicesAlways** - requires NSLocationAlwaysUsageDescription entry in plist

## Usage

1. Setup PermissionsCenter with background view for Request Button
2. Add Permissions to monitor
3. Check Permissions

## Example

        PermissionsCenter.shared.setup(headerView)
        PermissionsCenter.shared.addPermission(PermissionType.LocalNotifications) //Local Notifaciton last/first to show, because no callback
        PermissionsCenter.shared.addPermission(PermissionType.LocationServiceAlways)
        PermissionsCenter.shared.checkAllPermissions()
        PermissionsCenter.shared.actOnNextMissingPermission()
