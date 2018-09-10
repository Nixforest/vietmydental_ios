//
//  CustomerInfoRespModel.swift
//  dental
//
//  Created by SPJ on 2/2/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class CustomerInfoRespBean: BaseRespModel {
    // MARK: Properties
    /** Data */
    var data:          [ConfigExtBean] = [ConfigExtBean]()
    
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
                
                if let dataArr = json[DomainConst.KEY_DATA] as? [[String: AnyObject]] {
                    for item in dataArr {
                        self.data.append(ConfigExtBean(jsonData: item))
                    }
                }
            } catch let error as NSError {
                print(DomainConst.JSON_ERR_FAILED_LOAD + "\(error.localizedDescription)")
            }
        } else {
            print(DomainConst.JSON_ERR_WRONG_FORMAT)
        }
    }
}
