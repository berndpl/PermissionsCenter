//
//  Logger.swift
//  Onelist
//
//  Created by Bernd Plontsch on 08/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class Logger: NSObject {
    
    class func log (logSwitch:Bool,logMessage:NSString) {
        if logSwitch == true {
            println(logMessage)
        }
    }
}
