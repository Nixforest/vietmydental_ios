//
//  LoginRespBean.swift
//  dental
//
//  Created by SPJ on 1/10/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class LoginRespBean: BaseRespModel {
    var data:       LoginBean = LoginBean()
    
    override init() {
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
                    self.data = LoginBean(jsonData: dataArr)
                }
            } catch let error as NSError {
                print(DomainConst.JSON_ERR_FAILED_LOAD + "\(error.localizedDescription)")
            }
        } else {
            print(DomainConst.JSON_ERR_WRONG_FORMAT)
        }
    }
    
    public func getAllAgentConfigBean() -> ConfigBean {
        return LoginBean.shared.list_agent[0]
    }
    
    /**
     * Handle save config data
     * - parameter data: LoginRespBean
     */
    public static func saveConfigData(data: LoginRespBean) {
        BaseModel.shared.setListMenu(listMenu: data.data.menu)
        LoginBean.shared.pathological       = data.data.pathological
//        LoginBean.shared.status_treatment   = data.data.status_treatment
        LoginBean.shared.address_config     = data.data.address_config
        LoginBean.shared.diagnosis          = data.data.diagnosis
        LoginBean.shared.teeth              = data.data.teeth
        LoginBean.shared.treatment          = data.data.treatment
        LoginBean.shared.id                 = data.data.id
        LoginBean.shared.timer              = data.data.timer
        LoginBean.shared.diagnosis_other_id = data.data.diagnosis_other_id
        LoginBean.shared.list_agent         = data.data.list_agent
        LoginBean.shared.status_receipt     = data.data.status_receipt
        LoginBean.shared.user_agents_id     = data.data.user_agents_id
        LoginBean.shared.app_page_size      = data.data.app_page_size
        LoginBean.shared.report_status_list = data.data.report_status_list
        LoginBean.shared.customer_id        = data.data.customer_id
    }
}
