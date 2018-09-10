//
//  PathologicalCreateResp.swift
//  dental
//
//  Created by Pham Trung Nguyen on 5/8/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class PathologicalCreateResp: BaseRespModel {
    // MARK: Properties
    /** Data */
    var data:           ConfigExtBean = ConfigExtBean()
    
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
                    self.data = ConfigExtBean.init(jsonData: dataArr)
                }
            } catch let error as NSError {
                print(DomainConst.JSON_ERR_FAILED_LOAD + "\(error.localizedDescription)")
            }
        } else {
            print(DomainConst.JSON_ERR_WRONG_FORMAT)
        }
    }
}
