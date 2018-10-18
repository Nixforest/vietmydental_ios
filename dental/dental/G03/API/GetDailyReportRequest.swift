//
//  GetDailyReportRequest.swift
//  dental
//  P0033_DailyReportList_API
//  Created by Pham Trung Nguyen on 10/18/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class GetDailyReportRequest: BaseRequest {
    /**
     * Set data content
     * - parameter month:        Page index
     */
    func setData(month: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,          BaseModel.shared.getUserToken(),
            DomainConst.KEY_MONTH,          month,
            DomainConst.KEY_PLATFORM,       DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request list daily reports
     * - parameter view:                Current view
     * - parameter month:               Page index
     * - parameter completionHandler:   Action execute when finish this task
     */
    public static func request(view: BaseViewController,
                               month: String,
                               completionHandler: ((Any?) -> Void)?) {
        let request = GetDailyReportRequest(
            url: G03Const.PATH_DAILY_REPORT_LIST,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(month: month)
        request.completionBlock = completionHandler
        request.execute()
    }
}
