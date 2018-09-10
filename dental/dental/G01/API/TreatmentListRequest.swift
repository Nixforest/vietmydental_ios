//
//  TreatmentListRequest.swift
//  dental
//  P0018_GetListTreatment_API
//  Created by SPJ on 2/17/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class TreatmentListRequest: BaseRequest {
    /**
     * Set data content
     * - parameter page:        Page index
     * - parameter id:          Id of customer
     */
    func setData(page: String, id: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,          BaseModel.shared.getUserToken(),
            DomainConst.KEY_ID,             id,
            DomainConst.KEY_PAGE,           page,
            DomainConst.KEY_PLATFORM,       DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request generate OTP
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     * - parameter page:        Page index
     * - parameter id:          Id of customer
     * - parameter isShowLoading:   Flag show loading
     */
    public static func request(action: Selector, view: BaseViewController,
                               page: String, id: String,
                               isShowLoading: Bool = true) {
        let request = TreatmentListRequest(
            url: G01Const.PATH_TREATMENT_LIST,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(page: page, id: id)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute(isShowLoadingView: isShowLoading)
    }
}
