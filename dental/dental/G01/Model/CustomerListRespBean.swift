//
//  CustomerListRespModel.swift
//  dental
//
//  Created by SPJ on 2/2/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class CustomerListRespBean: BaseRespModel {
    // MARK: Properties
    /** Data */
    var data:          CustomerListBean = CustomerListBean()
    
    public override init() {
        super.init()
    }
    
    /**
     * Initializer
     */
    override public init(jsonString: String) {
        // Call super initializer
        super.init(jsonString: jsonString)
        
        // Start parse
        if let jsonData = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: AnyObject]
                if let dataArr = json[DomainConst.KEY_DATA] as? [String: AnyObject] {
                    self.data = CustomerListBean(jsonData: dataArr)
                }
            } catch let error as NSError {
                print(DomainConst.JSON_ERR_FAILED_LOAD + "\(error.localizedDescription)")
            }
        } else {
            print(DomainConst.JSON_ERR_WRONG_FORMAT)
        }
    }
    
    /**
     * Get list of data
     * - returns: List of data
     */
    public func getList() -> [CustomerBean] {
        return self.data._list
    }
    
    /**
     * Update data
     * - parameter bean: CustomerListBean
     */
    public func updateData(bean: CustomerListBean) {
        self.data._list.append(contentsOf: bean._list)
        self.data.setTotal(record: bean.getTotalRecord(), page: bean.getTotalPage())
    }
    
    /**
     * Clear data
     */
    public func clearData() {
        self.data.setTotal(record: 0, page: 0)
        self.data._list.removeAll()
    }
}

