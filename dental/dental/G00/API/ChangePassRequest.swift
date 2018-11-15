//
//  ChangePassRequest.swift
//  dental
//
//  Created by Lâm Phạm on 10/31/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class ChangePassResponse: NSObject {
    var status: Bool = false
    var message: String = ""
}

class ChangePassRequest: MasterModel {
    @objc dynamic var old_password: String = ""
    @objc dynamic var new_password: String = ""
}

extension Service {
    /** User change password */
    func changePassword(para: ChangePassRequest, success: @escaping((ChangePassResponse) -> Void), failure: @escaping((APIResponse) -> Void)) {
        let url = ServiceConfig.shared.url + "user/changePass"
        let body = CommonProcess.getStringBody(parameter: para.dictionary() as Dictionary<String, AnyObject>)
        let baseReq = BaseRequest(url: url, method: DomainConst.HTTP_POST_REQUEST, body: body)
        baseReq.execute { (response) in
            if response.status == 1 {
                let resp = ChangePassResponse()
                resp.status = true
                resp.message = response.message
                success(resp)
            } else {
                failure(response)
            }
        }
    }
}








