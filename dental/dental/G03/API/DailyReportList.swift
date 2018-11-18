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
    
    case new
    case process
    case confirm
    case cancel
    case notCreated
    case shouldReview
    case unknow
    
    static func getStatus(byID id: String) -> DailyReportStatus {
        switch id {
        case DomainConst.REPORT_STATUS_CANCEL:
            return .cancel
        case DomainConst.REPORT_STATUS_CONFIRM:
            return .confirm
        case DomainConst.REPORT_STATUS_NEW:
            return .new
        case DomainConst.REPORT_STATUS_PROCESS:
            return .process
        case DomainConst.REPORT_STATUS_SHOULD_REVIEW:
            return .shouldReview
        case DomainConst.REPORT_STATUS_NOT_CREATED_YET:
            return .notCreated
        default:
            return .unknow
        }
    }
    
    func getImage() -> UIImage {
        switch self {
        case .cancel:
            return UIImage(named: "report_status_cancel")!
        case .confirm:
            return UIImage(named: "report_status_approved")!
        case .new:
            return UIImage(named: "report_status_active")!
        case .process:
            return UIImage(named: "report_status_request")!
        case .shouldReview:
            return UIImage(named: "report_status_request")!
        case .notCreated:
            return UIImage(named: "report_status_new")!
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








