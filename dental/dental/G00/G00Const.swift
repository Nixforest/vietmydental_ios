//
//  G00Const.swift
//  project
//
//  Created by SPJ on 10/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G00Const: NSObject {
    /** Function identifier */
    public static let FUNC_IDENTIFIER                           = DomainConst.APPNAME + "g00"
    /** Path to connect with PHP server */
    public static let PATH_CUSTOMER_GENERATE_OTP                = "customer/generateOTP"
    /** Path to connect with PHP server */
    public static let PATH_USER_CHANGE_PROFILE                  = "user/update"

}
