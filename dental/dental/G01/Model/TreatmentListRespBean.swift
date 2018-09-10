//
//  TreatmentListRespBean.swift
//  dental
//
//  Created by SPJ on 2/17/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class TreatmentListRespBean: BaseRespModel {
    // MARK: Properties
    /** Data */
    var data:          TreatmentListBean = TreatmentListBean()
    
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
                    self.data = TreatmentListBean(jsonData: dataArr)
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
    public func getList() -> [ConfigExtBean] {
        return self.data._list
    }
    
    /**
     * Update data
     * - parameter bean: TreatmentListBean
     */
    public func updateData(bean: TreatmentListBean) {
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
