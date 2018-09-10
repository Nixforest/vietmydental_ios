//
//  CustomerList.swift
//  dental
//
//  Created by Lâm Phạm on 1/19/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit

class CustomerList: MasterModel {
    var total_record: Int = 0
    var total_page: Int = 1
    var list: [NSDictionary] = []
    var listCustomer: [CustomerListUnit] = []
}
class CustomerList_Request: MasterModel {
    var page: Int = 0
}
class CustomerListUnit: MasterModel {
    var id: String = ""
    var name: String = ""
    var gender: String = ""
    var age: String = ""
    var phone: String = ""
    var address: String = ""
    
    class func listed(arrDict: [NSDictionary]) -> [CustomerListUnit] {
        var output: [CustomerListUnit] = []
        for dict in arrDict {
            let unit = CustomerListUnit.init(dictionary: dict)
            output.append(unit)
        }
        return output
    }
}


extension Service {
    func getListCustomer(param: CustomerList_Request, success: @escaping((CustomerList) -> Void), failure: @escaping((APIResponse) -> Void)) {
        serviceInstance.request(api: .getListCustomer, method: .post, parameter: param.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            let list = CustomerList.init(dictionary: response.data as! NSDictionary)
            list.listCustomer = CustomerListUnit.listed(arrDict: list.list)
            success(list)
        }) { (error) in
            failure(error)
        }
    }
}










