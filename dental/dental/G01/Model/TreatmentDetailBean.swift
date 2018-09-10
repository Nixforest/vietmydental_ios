//
//  TreatmentDetail.swift
//  dental
//
//  Created by SPJ on 2/18/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class TreatmentDetailBean: TreatmentBean {
    /** Teeth */
    var teeth:                  String              = DomainConst.BLANK
    /** Treatment */
    var treatment:              String              = DomainConst.BLANK
    /** Note */
    var note:                   String              = DomainConst.BLANK
    /** Status */
//    var status:                 String              = DomainConst.BLANK
    /** Type */
    var type:                   String              = DomainConst.BLANK
    
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public override init(jsonData: [String: AnyObject]) {
        super.init(jsonData: jsonData)
        self.teeth      = getString(json: jsonData, key: DomainConst.KEY_TEETH)
        self.treatment  = getString(json: jsonData, key: DomainConst.KEY_TREATMENT)
        self.note       = getString(json: jsonData, key: DomainConst.KEY_NOTE)
//        self.status     = getString(json: jsonData, key: DomainConst.KEY_STATUS)
        self.type       = getString(json: jsonData, key: DomainConst.KEY_TYPE)
    }
}
