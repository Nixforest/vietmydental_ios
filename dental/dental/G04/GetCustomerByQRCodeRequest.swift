//
//  GetCustomerByQRCodeRequest.swift
//  dental
//
//  Created by Lâm Phạm on 10/16/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class GetCustomerByQRCodeRequest: MasterModel {
    @objc dynamic var qr: String = ""
}

class GetCustomerByQRCodeResponse: NSObject {
    var customerID: String = ""
}

extension Service {
    func getCustomerByQRCode(param: GetCustomerByQRCodeRequest, success: @escaping((GetCustomerByQRCodeResponse)->Void), failure: @escaping((APIResponse)->Void)) {
        let url = serviceConfig.url + "customer/getByQRCode"
        let body = CommonProcess.getStringBody(parameter: param.dictionary() as Dictionary<String, AnyObject>)
        let baseReq = BaseRequest(url: url, method: DomainConst.HTTP_POST_REQUEST, body: body)
        baseReq.execute { (response) in
            if response.status == 1 {
//                let data = response.data as! NSDictionary
                let result = GetCustomerByQRCodeResponse()
                result.customerID = response.data as! String
                success(result)
            } else {
                failure(response)
            }
        }
    }
}






