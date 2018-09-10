//
//  Agent.swift
//  dental
//
//  Created by Lâm Phạm on 8/1/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit

class Agent: MasterModel {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var foundation_date: String = ""
    @objc dynamic var city_id: Int = 0
    @objc dynamic var district_id = 0
    @objc dynamic var ward_id = 0
    @objc dynamic var street_id: Int = 0
    @objc dynamic var house_numbers: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var address_vi: String = ""
    @objc dynamic var created_by: Int = 0
    @objc dynamic var created_date: String = ""
    @objc dynamic var statusInt = 0
    
    @objc dynamic var isSelected: Bool = false
    
    override init(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
    }
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    class func listed(listDict: [NSDictionary]) -> [Agent] {
        var output = [Agent]()
        for dict in listDict {
            let agent = Agent(dictionary: dict)
            output.append(agent)
        }
        return output
    }
}







