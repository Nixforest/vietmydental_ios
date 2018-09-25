//
//  StatisticsModel.swift
//  dental
//
//  Created by Lâm Phạm on 8/16/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class StatisticsModel: NSObject {
    var discount: String = ""
    var total: String = ""
    var final: String = ""
    var debt: String = ""
    var customerCount: String = ""
    
    init(dict: NSDictionary) {
        discount = (dict.object(forKey: "discount_amount") as! String)
        total = (dict.object(forKey: "total") as! String)
        final = (dict.object(forKey: "final") as! String)
        debt = (dict.object(forKey: "debt") as! String)
        customerCount = (dict.object(forKey: "total_qty") as! String)
    }
}

class MedicalReceipt: NSObject {
    
    var data: ListConfigBean = ListConfigBean()
    
    init(listDict: [NSDictionary]) {
        var jsondata = [[String: AnyObject]]()
        for dict in listDict {
            for item in dict.allKeys {
                jsondata.append([item as! String: dict.object(forKey: item as! String) as AnyObject])
            }
        }
        self.data = ListConfigBean(jsonData: listDict as! [[String: AnyObject]])
        super.init()
    }
}

class GetListReceiptRequest: MasterModel {
    @objc dynamic var agent_id: String = ""
    @objc dynamic var date_from: String = ""
    @objc dynamic var date_to: String = ""
    @objc dynamic var page: String = ""
    @objc dynamic var status: String = ""
}

class GetStatisticsRequest: MasterModel {
    @objc dynamic var agent_id: String = ""
    @objc dynamic var date_from: String = ""
    @objc dynamic var date_to: String = ""
    
    func getAgentID(listAgents: [ConfigBean]) -> String {
        var retVal = ""
        var arr = [String]()
        for agent in listAgents {
            arr.append(agent.id)
        }
        retVal = arr.joined(separator: DomainConst.SPLITER_TYPE2)
        retVal = "[\(retVal)]"
        return retVal
    }
}

extension Service {
    func getStatistics(req: GetStatisticsRequest, success: @escaping((StatisticsModel) -> Void), failure: @escaping((APIResponse) -> Void)) {
        let url = serviceConfig.url + "report/getStatistic"
        let body = CommonProcess.getStringBody(parameter: req.dictionary() as Dictionary<String, AnyObject>)
        let baseReq = BaseRequest(url: url, method: DomainConst.HTTP_POST_REQUEST, body: body)
        
        baseReq.execute { (response) in
            if response.status == 1 {
                success(StatisticsModel(dict: response.data as! NSDictionary))
            } else {
                failure(response)
            }
        }
    }
    func getListReceipt(req: GetListReceiptRequest, success: @escaping((MedicalReceipt) -> Void), failure: @escaping((APIResponse) -> Void)) {
        let url = serviceConfig.url + "report/listReceipts"
        let body = CommonProcess.getStringBody(parameter: req.dictionary() as Dictionary<String, AnyObject>)
        let baseReq = BaseRequest(url: url, method: DomainConst.HTTP_POST_REQUEST, body: body)
        
        baseReq.execute { (response) in
            if response.status == 1 {
                let dict = response.data as! NSDictionary
                let list = dict.object(forKey: "list") as! [NSDictionary]
                success(MedicalReceipt.init(listDict: list))
            } else {
                failure(response)
            }
        }
    }
}









