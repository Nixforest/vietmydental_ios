//
//  GetDomainRequest.swift
//  dental
//
//  Created by Lâm Phạm on 9/3/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class GetDomainRequest: MasterModel {
    @objc dynamic var bundle_id = ""
}

extension Service {
    func getDomain(param: GetDomainRequest, success: @escaping((String) -> Void), failure: @escaping((APIResponse) -> Void)) {
        let url = "http://nixforest.com/index.php/api/default/getDomainName"
        let body = CommonProcess.getStringBody(parameter: param.dictionary() as Dictionary<String, AnyObject>)
        let baseReq = BaseRequest(url: url, method: DomainConst.HTTP_POST_REQUEST, body: body)
        baseReq.execute { (response) in
            if response.status == 1 {
                success(response.data as! String)
            } else {
                failure(response)
            }
        }
    }
}















