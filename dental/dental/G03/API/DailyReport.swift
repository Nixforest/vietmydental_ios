//
//  DailyReport.swift
//  dental
//
//  Created by Lâm Phạm on 10/4/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class DailyReport: NSObject {
    /** list of daily report  of all agent in day */
    var data: [ConfigExtBean] = []
    
    override init() {
        super.init()
    }
    
    init(fromNSDictionaryArray arrDict: [NSDictionary]) {
        for dict in arrDict {
            let bean = ConfigExtBean(jsonData: dict as! [String: AnyObject])
            data.append(bean)
        }
    }
}

class DailyReportRequest: MasterModel {
    /** date string with format yyyy-MM-dd */
    @objc dynamic var date: String = ""
}

extension Service {
    /** get agent report list by day */
    func getDailyReport(req: DailyReportRequest, success: @escaping((DailyReport) -> Void), failure: @escaping((APIResponse) -> Void)) {
        let url = ServiceConfig.shared.url + "report/dailyReport"
        let body = CommonProcess.getStringBody(parameter: req.dictionary() as Dictionary<String, AnyObject>)
        let baseReq = BaseRequest(url: url, method: DomainConst.HTTP_POST_REQUEST, body: body)
        baseReq.execute { (response) in
            if response.status == 1 {
                if let data = response.data as? [NSDictionary] {
                    success(DailyReport.init(fromNSDictionaryArray: data))
                }
            } else {
                failure(response)
            }
        }
    }
}















