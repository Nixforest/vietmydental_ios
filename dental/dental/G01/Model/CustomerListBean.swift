    //
//  CustomerListBean.swift
//  dental
//
//  Created by SPJ on 2/2/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class CustomerListBean: ListBean {
    // MARK: Properties
    var _list:          [CustomerBean] = [CustomerBean]()
    
    public override init() {
        super.init()
    }
    
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public override init(jsonData: [String: AnyObject]) {
        super.init(jsonData: jsonData)
        if let dataArr = jsonData[DomainConst.KEY_LIST] as? [[String: AnyObject]] {
            for item in dataArr {
                self._list.append(CustomerBean(jsonData: item))
            }
        }
    }
}
