//
//  ServiceConfig.swift
//  dental
//
//  Created by Lâm Phạm on 1/11/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework


class ServiceConfig: NSObject {
    let url = BaseModel.shared.getServerURL()
    var token = ""
    
    static let shared = ServiceConfig()
    
}


