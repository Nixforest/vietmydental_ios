//
//  CustomerInfo.swift
//  dental
//
//  Created by Lâm Phạm on 1/14/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit

class CustomerInfo: MasterObject {
    var listInfo = [MasterObject]()
}
class CustomerInfo_Request: MasterModel {
    var id = ""
    
}

extension Service {
    func getCustomerInfo(param:CustomerInfo_Request, success: @escaping ((CustomerInfo)->Void), failure: @escaping ((APIResponse)->Void)) {
        serviceInstance.request(api: .getCustomerInfo, method: .post, parameter: param.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            let customer = CustomerInfo()
            customer.listInfo = CustomerInfo.listed(dicts: response.data as! [NSDictionary])
            success(customer)
        }) { (error) in
            failure(error)
        }
    }
}
