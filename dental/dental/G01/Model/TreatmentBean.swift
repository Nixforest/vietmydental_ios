//
//  TreatmentBean.swift
//  dental
//
//  Created by SPJ on 2/2/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class TreatmentBean: ConfigBean {
    /** Start date */
    var start_date:             String              = DomainConst.BLANK
    /** End date */
    var end_date:               String              = DomainConst.BLANK
    /** Diagnosis */
    var diagnosis:              String              = DomainConst.BLANK
    /** Status */
    var status:                 String              = DomainConst.BLANK
    
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public override init(jsonData: [String: AnyObject]) {
        super.init(jsonData: jsonData)
        self.start_date = getString(json: jsonData, key: DomainConst.KEY_START_DATE)
        self.end_date = getString(json: jsonData, key: DomainConst.KEY_END_DATE)
        self.diagnosis = getString(json: jsonData, key: DomainConst.KEY_DIAGNOSIS)
        self.status = getString(json: jsonData, key: DomainConst.KEY_STATUS)
    }
}
