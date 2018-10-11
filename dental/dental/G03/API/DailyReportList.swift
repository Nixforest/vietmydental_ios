//
//  DailyReportList.swift
//  dental
//
//  Created by Lâm Phạm on 10/3/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

enum DailyReportStatus {
    
    case unapproved
    case requestApprove
    case approved
    case refuse
    case notCreated
    case needCheck
    case unknow
    
    static func getStatus(byID id: String) -> DailyReportStatus {
        switch id {
        case DomainConst.REPORT_STATUS_REFUSE:
            return .refuse
        case DomainConst.REPORT_STATUS_APPROVED:
            return .approved
        case DomainConst.REPORT_STATUS_UNAPPROVED:
            return .unapproved
        case DomainConst.REPORT_STATUS_REQUEST_APPROVE:
            return .requestApprove
        case DomainConst.REPORT_STATUS_NEED_CHECK:
            return .needCheck
        case DomainConst.REPORT_STATUS_NOT_CREATED:
            return .notCreated
        default:
            return .unknow
        }
    }
    
    func getImage() -> UIImage {
        switch self {
        case .unapproved:
            return #imageLiteral(resourceName: "report_status_unapproved")
        case .approved:
            return #imageLiteral(resourceName: "report_status_approved")
        case .requestApprove:
            return #imageLiteral(resourceName: "report_status_approved")
        case .refuse:
            return #imageLiteral(resourceName: "report_status_refuse")
        case .notCreated:
            return #imageLiteral(resourceName: "report_status_not_created")
        case .needCheck:
            return #imageLiteral(resourceName: "report_status_approved")
        default:
            return UIImage()
        }
    }
}

class DailyReportList: NSObject {
    
    /** list of all report */
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

class DailyReportListRequest: MasterModel {
    /** date string format yyyy/MM */
    @objc dynamic var month: String = ""
}

extension Service {
    /** get daily report list */
    func getDailyReportList(req: DailyReportListRequest, success: @escaping((DailyReportList) -> Void), failure: @escaping((APIResponse) -> Void)) {
        let url = ServiceConfig.shared.url + "report/dailyReportList"
        let body = CommonProcess.getStringBody(parameter: req.dictionary() as Dictionary<String, AnyObject>)
        let baseReq = BaseRequest(url: url, method: DomainConst.HTTP_POST_REQUEST, body: body)
        baseReq.execute { (response) in
            if response.status == 1 {
                if let data = response.data as? [NSDictionary] {
                    success(DailyReportList.init(fromNSDictionaryArray: data))
                }
            } else {
                failure(response)
            }
        }
    }
}








