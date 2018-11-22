//
//  LoginBean.swift
//  dental
//
//  Created by SPJ on 1/9/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class LoginBean: ConfigBean {
    /**
     * Object instance
     */
    public static let shared: LoginBean = {
        let instance = LoginBean()
        return instance
    }()
    // MARK: Properties
    /** User token */
    var token:              String          = DomainConst.BLANK
    /** Id of role */
    var role_id:            String          = DomainConst.BLANK
    /** Flag need change pass */
    var need_change_pass:   String          = DomainConst.BLANK
    /** List menu */
    var menu:               [ConfigBean]    = [ConfigBean]()
    /** Pathological config */
    var pathological:       [ConfigBean]    = [ConfigBean]()
    /** Address config */
    var address_config:     [ConfigBean]    = [ConfigBean]()
    /** Diagnosis config */
    var diagnosis:          [ConfigBean]    = [ConfigBean]()
    /** Treatment type config */
    var treatment:          ListConfigBean  = ListConfigBean()
    /** Teeth config */
    var teeth:              [ConfigBean]    = [ConfigBean]()
    /** Timer config */
    var timer:              [ConfigBean]    = [ConfigBean]()
    /** Id of diagnosis other */
    var diagnosis_other_id: String          = DomainConst.BLANK
    /** Agent List config */
    var list_agent:        [ConfigBean]     = [ConfigBean]()
    /** Agent ID List */
    var user_agents_id:        String       = ""
    /** status receipt config */
    var status_receipt:    [ConfigBean]     = [ConfigBean]()
    /** report status list */
    var report_status_list:    [ConfigBean]     = [ConfigBean]()
    
    var app_page_size: String               = ""
    var customer_id: String                 = ""
    
    override public init() {
        super.init()
    }
    
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public override init(jsonData: [String: AnyObject]) {
        super.init(jsonData: jsonData)
        // Token
        self.token = getString(json: jsonData, key: DomainConst.KEY_TOKEN)
        // Role id
        self.role_id = getString(json: jsonData, key: DomainConst.KEY_ROLE_ID)
        // Flag need change password
        self.need_change_pass = getString(json: jsonData, key: DomainConst.KEY_NEED_CHANGE_PASS)
        // Menu
        self.menu.append(contentsOf: getListConfig(json: jsonData, key: DomainConst.KEY_MENU))
        // Pathological
        self.pathological.append(contentsOf: getListConfig(json: jsonData, key: DomainConst.KEY_PATHOLOGICAL))
        self.address_config.append(contentsOf: getListConfig(json: jsonData, key: DomainConst.KEY_ADDRESS_CONFIG))
        // Diagnosis
        self.diagnosis.append(contentsOf: getListConfig(json: jsonData, key: DomainConst.KEY_DIAGNOSIS))
        // Treatment
        if let dataArr = jsonData[DomainConst.KEY_TREATMENT] as? [[String: AnyObject]] {
            self.treatment = ListConfigBean.init(jsonData: dataArr)
        }
        // Teeth
        self.teeth.append(contentsOf: getListConfig(json: jsonData, key: DomainConst.KEY_TEETH))
        // Timer
        self.timer.append(contentsOf: getListConfig(json: jsonData, key: DomainConst.KEY_TIMER))
        // Diagnosis other id
        self.diagnosis_other_id = getString(json: jsonData, key: DomainConst.KEY_DIAGNOSIS_OTHER_ID)
        // List agents
        self.list_agent.append(contentsOf: getListConfig(json: jsonData, key: DomainConst.KEY_LIST_AGENT))
        // List user agents id
        self.user_agents_id = getString(json: jsonData, key: DomainConst.KEY_AGENT_ID)
        // Status receipt
        self.status_receipt.append(contentsOf: getListConfig(json: jsonData, key: DomainConst.KEY_STATUS_RECEIPT))
        self.report_status_list.append(contentsOf: getListConfig(json: jsonData, key: DomainConst.KEY_DAILY_REPORT_STATUS))
        // App page size
        self.app_page_size = getString(json: jsonData, key: DomainConst.KEY_APP_API_LIST_PAGE_SIZE)
        
        // Customer ID
        self.customer_id = getString(json: jsonData, key: DomainConst.KEY_CUSTOMER_ID)
    }
    
    /**
     * Get city by id
     * - parameter id:      Id of city
     * - returns: City model
     */
    public func getCityById(id: String) -> ConfigBean {
        for item in self.address_config {
            if item.id == id {
                return item
            }
        }
        return ConfigBean()
    }
    
    /**
     * Get district by id
     * - parameter id:          Id of district
     * - parameter cityId:      Id of city
     * - returns: District model
     */
    public func getDistrictById(id: String, cityId: String) -> ConfigBean {
        for item in self.getCityById(id: cityId).data {
            if item.id == id {
                return item
            }
        }
        return ConfigBean()
    }
    
    /**
     * Get ward by id
     * - parameter id:          Id of ward
     * - parameter cityId:      Id of city
     * - parameter districtId:  Id of district
     * - returns: Ward model
     */
    public func getWardById(id: String, cityId: String, districtId: String)
        -> ConfigBean {
            for item in self.getDistrictById(id: districtId, cityId: cityId).data {
                if item.id == id {
                    return item
                }
            }
            return ConfigBean()
    }
    
    /**
     * Get diagnosis configs
     * - returns: List config bean
     */
    public func getDiagnosisConfigs() -> [ConfigBean] {
        var retVal = [ConfigBean]()
        for item in self.diagnosis {
            if !item.data.isEmpty {
                for child in item.data {
                    retVal.append(child)
                }
            }
        }
        return retVal
    }
    
    /**
     * Get diagnosis config value
     * - parameter id:          Id of config
     */
    public func getDiagnosisConfig(id: String) -> String {
        for item in self.diagnosis {
            if item.id == id {
                return item.name
            } else {
                // Find in children list
                for child in item.data {
                    if child.id == id {
                        let arrData = child.name.components(separatedBy: " - ")
                        
                        return arrData[0] + " - " + arrData[1]
                    }
                }
            }
        }
        return DomainConst.BLANK
    }
    
    /**
     * Get diagnosis config id by name
     * - parameter name: Name of config
     * - returns: Id of config
     */
    public func getDiagnosisConfigIdByName(name: String) -> String {
        for item in self.diagnosis {
            if item.name == name {
                return item.id
            }
        }
        return DomainConst.BLANK
    }
    
    /**
     * Get treatment config value
     * - parameter id: Id of config
     */
    public func getTreatmentConfig(id: String) -> ConfigExtBean {
        for item in self.treatment.getData() {
            for child in item._dataExt {
                if child.id == id {
                    return child
                }
            }
        }
        return ConfigExtBean.init()
    }
    
    /**
     * Get teeth config value
     * - parameter id:          Id of config
     */
    public func getTeethConfig(id: String) -> String {
        for item in self.teeth {
            if item.id == id {
                return item.name
            }
        }
        return DomainConst.BLANK
    }
    
    /**
     * Get update text string
     * - returns: String
     */
    public func getUpdateText() -> String {
        return DomainConst.CONTENT00555
    }
    
    /**
     * Get user id
     * - returns: User id
     */
    public func getUserId() -> String {
        return self.id
    }
    
    /**
     *  Get receipt status collected
     */
    func getReceiptStatusCollected() -> ConfigBean {
        for bean in self.status_receipt {
            if bean.id == DomainConst.RECEIPT_STATUS_COLLECTED {
                return bean
            }
        }
        return ConfigBean()
    }
    /**
     *  Get receipt status not collected
     */
    func getReceiptStatusNotCollected() -> ConfigBean {
        for bean in self.status_receipt {
            if bean.id == DomainConst.RECEIPT_STATUS_NOT_COLLECTED {
                return bean
            }
        }
        return ConfigBean()
    }
    
    /**
     * Get timer config value
     * - parameter id:          Id of config
     */
    public func getTimerConfig(id: String) -> String {
        for item in self.timer {
            if item.id == id {
                return item.name
            }
        }
        return DomainConst.BLANK
    }
    
    /**
     * Add pathological
     * - parameter bean: Object to add
     */
    public func addPathological(bean: ConfigBean) {
        pathological.append(bean)
    }
    
    /**
     * Add new diagnosis
     * - parameter bean: Object to add
     * - parameter parent_id: Id of parent object
     */
    public func addDiagnosis(bean: ConfigBean, parent_id: String) {
        for item in self.diagnosis {
            if item.id == parent_id {
                item.data.append(bean)
            }
        }
    }
    
    /**
     * Add new diagnosis
     * - parameter bean: Object to add
     * - parameter parent_id: Id of parent object
     */
    public func addDiagnosisToOther(bean: ConfigBean) {
        for item in self.diagnosis {
            if item.id == self.diagnosis_other_id {
                item.data.append(bean)
            }
        }
    }
}
