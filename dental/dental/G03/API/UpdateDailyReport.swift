//
//  UpdateDailyReport.swift
//  dental
//
//  Created by Lâm Phạm on 10/10/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class UpdateDailyReport: NSObject {
    var message: String = ""
    var isSuccess: Bool = false
    var data: ConfigExtBean!
}

class UpdateDailyReportRequest: MasterModel {
    /** id of report need update */
    @objc dynamic var id: String = ""
    /** id of report status bean */
    @objc dynamic var status: String = ""
}

extension Service {
    func updateReportStatus(req: UpdateDailyReportRequest, success: @escaping((UpdateDailyReport) -> Void), failure: @escaping((APIResponse) -> Void)) {
        let url = ServiceConfig.shared.url + "report/updateDailyReport"
        let body = CommonProcess.getStringBody(parameter: req.dictionary() as Dictionary<String, AnyObject>)
        let baseReq = BaseRequest(url: url, method: DomainConst.HTTP_POST_REQUEST, body: body)
        baseReq.execute { (response) in
            if response.status == 1 {
                let result = UpdateDailyReport()
                if let data = response.data as? [String: AnyObject] {
                    result.data = ConfigExtBean(jsonData: data)
                }
                result.message = response.message
                result.isSuccess = true
                success(result)
            } else {
                failure(response)
            }
        }
    }
}














