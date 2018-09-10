//
//  ServiceConfig.swift
//  dental
//
//  Created by Lâm Phạm on 1/11/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework


let  serviceConfig = ServiceConfig.sharedInstance()


class ServiceConfig: NSObject {
    let url = BaseModel.shared.getServerURL()
    var token = ""
    
    static var instance: ServiceConfig!
    
    class func sharedInstance() -> ServiceConfig {
        if(self.instance == nil) {
            self.instance = (self.instance ?? ServiceConfig())
        }
        return self.instance
    }
    
}


