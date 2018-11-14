//
//  CustomerLogin.swift
//  dental
//
//  Created by Lâm Phạm on 11/13/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class CustomerLogin: NSObject {
    var isSuccess: Bool = false
    var message: String = ""
}

class CustomerLoginRequest: MasterModel {
    @objc dynamic var phone: String = ""
}

class LoginCustomerConfirmRequest: MasterModel {
    @objc dynamic var phone: String = ""
    @objc dynamic var otp: String = ""
    @objc dynamic private var gcm_device_token: String = ""
    @objc dynamic var apns_device_token: String = ""
    @objc dynamic private var app_type: String = ""
}


extension Service {
    func customerLogin(param: CustomerLoginRequest, success: @escaping((CustomerLogin) -> Void), failure: @escaping((APIResponse) -> Void)) {
        let url = ServiceConfig.shared.url + "default/loginCustomer"
        let body = CommonProcess.getStringBody(parameter: param.dictionary() as Dictionary<String, AnyObject>)
        serviceInstance.request(url: url, data: body, success: { (response) in
            let login = CustomerLogin()
            login.isSuccess = true
            login.message = response.message
            success(login)
        }) { (error) in
            failure(error)
        }
    }
    func loginCustomerConfirm(param: LoginCustomerConfirmRequest, success: @escaping((LoginRespBean) -> Void), failure: @escaping((APIResponse) -> Void)) {
        let url = ServiceConfig.shared.url + "default/loginCustomerConfirm"
        let body = CommonProcess.getStringBody(parameter: param.dictionary() as Dictionary<String, AnyObject>)
        serviceInstance.request(url: url, data: body, success: { (response) in
            let bean = LoginRespBean()
            let intStatus = response.status
            bean.status = String(intStatus)
            bean.code = String(response.code)
            bean.message = response.message
            bean.data = LoginBean.init(jsonData: response.data as! [String: AnyObject])
            success(bean)
        }) { (error) in
            failure(error)
        }
    }
}
