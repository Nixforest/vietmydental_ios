//
//  UIDeviceExtension.swift
//  ReBook
//
//  Created by Lâm Phạm on 10/3/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import Foundation
import UIKit

enum DeviceModel: String {
    case iPhone5 = "iPhone 5"
    case iPhone6 = "iPhone 6"
    case iPad    = "iPad"
}

public extension UIDevice {
    
    func getDeviceModel() -> String {
        var output = DeviceModel.iPhone6.rawValue
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
//        print(identifier)
        switch identifier {
            case "iPod5,1":
                 output = DeviceModel.iPhone5.rawValue
            case "iPod7,1":
                 output = DeviceModel.iPhone5.rawValue
            case "i386":
                output = DeviceModel.iPhone5.rawValue
            case "x86_64": //identifier for simulator, can not know what model the simulator is
                output = DeviceModel.iPhone5.rawValue
            case "iPhone5,1", "iPhone5,2":
                output = DeviceModel.iPhone5.rawValue
            case "iPhone5,3", "iPhone5,4":
                output = DeviceModel.iPhone5.rawValue
            case "iPhone6,1", "iPhone6,2":
                output = DeviceModel.iPhone5.rawValue
            case "iPhone7,2":
                output = DeviceModel.iPhone6.rawValue
            case "iPhone7,1":
                output = DeviceModel.iPhone6.rawValue
            case "iPhone8,1":
                output = DeviceModel.iPhone6.rawValue
            case "iPhone8,2":
                output = DeviceModel.iPhone6.rawValue
            case "iPhone9,1", "iPhone9,3":
                output = DeviceModel.iPhone6.rawValue
            case "iPhone9,2", "iPhone9,4":
                output = DeviceModel.iPhone6.rawValue
            case "iPhone8,4": //iPhone SE
                output = DeviceModel.iPhone5.rawValue
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
                output = DeviceModel.iPad.rawValue
            case "iPad3,1", "iPad3,2", "iPad3,3":
                output = DeviceModel.iPad.rawValue
            case "iPad3,4", "iPad3,5", "iPad3,6":
                output = DeviceModel.iPad.rawValue
            case "iPad4,1", "iPad4,2", "iPad4,3":
                output = DeviceModel.iPad.rawValue
            case "iPad5,3", "iPad5,4":
                output = DeviceModel.iPad.rawValue
            case "iPad6,11", "iPad6,12":
                output = DeviceModel.iPad.rawValue
            case "iPad2,5", "iPad2,6", "iPad2,7":
                output = DeviceModel.iPad.rawValue
            case "iPad4,4", "iPad4,5", "iPad4,6":
                output = DeviceModel.iPad.rawValue
            case "iPad4,7", "iPad4,8", "iPad4,9":
                output = DeviceModel.iPad.rawValue
            case "iPad5,1", "iPad5,2":
                output = DeviceModel.iPad.rawValue
            case "iPad6,3", "iPad6,4":
                output = DeviceModel.iPad.rawValue
            case "iPad6,7", "iPad6,8":
                output = DeviceModel.iPad.rawValue
            case "iPad7,1", "iPad7,2":
                output = DeviceModel.iPad.rawValue
            case "iPad7,3", "iPad7,4":
                output = DeviceModel.iPad.rawValue
            default:
                output = DeviceModel.iPhone6.rawValue
        }
        return output
    }
    
}
