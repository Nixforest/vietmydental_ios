//
//  CustomerListRequest.swift
//  dental
//  P0007_CustomerList_API
//  Created by SPJ on 2/2/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class CustomerListRequest: BaseRequest {
    /**
     * Set data content
     * - parameter page:        Page index
     * - parameter type:        Type of customer
     */
    func setData(page: String, type: String, date: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,          BaseModel.shared.getUserToken(),
            DomainConst.KEY_PAGE,           page,
            DomainConst.KEY_TYPE,           type,
            DomainConst.KEY_PLATFORM,       DomainConst.PLATFORM_IOS
//            DomainConst.KEY_DATE_FROM,     date,
//            DomainConst.KEY_DATE_TO,       date
        )
    }
    
    /**
     * Request generate OTP
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     * - parameter page:        Page index
     * - parameter type:        Type of customer
     * - parameter date:        Date created
     */
    public static func request(action: Selector, view: BaseViewController,
                               page: String, type: String = "0", date: String) {
        let request = CustomerListRequest(
            url: G01Const.PATH_CUSTOMER_LIST,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(page: page, type: type, date: date)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
