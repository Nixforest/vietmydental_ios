//
//  CustomerBean.swift
//  dental
//
//  Created by SPJ on 2/2/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class CustomerBean: ConfigBean {
    // MARK: Properties
    /** Gender */
    var gender:             String          = DomainConst.BLANK
    /** Age */
    var age:                String          = DomainConst.BLANK
    /** Phone */
    var phone:              String          = DomainConst.BLANK
    /** Address */
    var address:            String          = DomainConst.BLANK  
    /** Birthday */
    var birthday:           String          = DomainConst.BLANK  
    /** Email */
    var email:              String          = DomainConst.BLANK  
    /** Agent */
    var agent:              String          = DomainConst.BLANK  
    /** Career */
    var career:             String          = DomainConst.BLANK  
    /** Characteristics */
    var characteristics:    String          = DomainConst.BLANK  
    /** Record number */
    var record_number:      String          = DomainConst.BLANK  
    /** Medical history */
    var medical_history:    [ConfigBean]    = [ConfigBean]()    
    
    override public init() {
        super.init()
    }
    
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public override init(jsonData: [String: AnyObject]) {
        super.init(jsonData: jsonData)
        // Gender
        self.gender = getString(json: jsonData, key: DomainConst.KEY_GENDER)
        // Age
        self.age = getString(json: jsonData, key: DomainConst.KEY_AGE)
        // Phone
        self.phone = getString(json: jsonData, key: DomainConst.KEY_PHONE)
        // Address
        self.address = getString(json: jsonData, key: DomainConst.KEY_ADDRESS)
        // Birthday
        self.birthday = getString(json: jsonData, key: DomainConst.KEY_BIRTHDAY)
        // Email
        self.email = getString(json: jsonData, key: DomainConst.KEY_EMAIL)
        // Agent
        self.agent = getString(json: jsonData, key: DomainConst.KEY_AGENT)
        // Career
        self.career = getString(json: jsonData, key: DomainConst.KEY_CAREER)
        // Characteristics
        self.characteristics = getString(json: jsonData,
                                         key: DomainConst.KEY_CHARACTERISTICS)
        // Record number
        self.record_number = getString(json: jsonData,
                                       key: DomainConst.KEY_RECORD_NUMBER)
        // Medical history
        self.medical_history = getListConfig(json: jsonData, key: DomainConst.KEY_MEDICAL_HISTORY)
    }
}
