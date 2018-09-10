//
//  LoginUser.swift
//  dental
//
//  Created by Lâm Phạm on 1/11/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit

class LoginUser: MasterModel {
    var token: String = ""
    var role_id: String = ""
    var need_change_pass: String = ""
}

class LoginUser_Resquest: MasterModel {
    var username: String = ""
    var password: String = ""
    var gcm_device_token: String = ""
    var apns_device_token: String = ""
    var app_type: String = ""
    var platform: Int = 2
    var version_code:String = "10"
}


extension Service {
    func login(param: LoginUser_Resquest, success: @escaping ((LoginUser)->Void), failure: @escaping ((APIResponse)->Void)) {
        serviceInstance.request(api: .loginUser, method: .post, parameter: param.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            success(LoginUser.init(dictionary: response.data as! NSDictionary))
        }) { (error) in
            failure(error)
        }
    }
}


