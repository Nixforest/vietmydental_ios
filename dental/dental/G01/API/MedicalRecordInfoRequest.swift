//
//  MedicalRecordInfoRequest.swift
//  dental
//  P0017_GetMedicalRecordInfo_API
//  Created by SPJ on 2/16/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class MedicalRecordInfoRequest: BaseRequest {
    /**
     * Set data content
     * - parameter id:        Customer id
     */
    func setData(id: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,      BaseModel.shared.getUserToken(),
            DomainConst.KEY_ID,         id,
            DomainConst.KEY_PLATFORM,   DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     * - parameter id:          Customer id
     * - parameter isShowLoading:   Flag show loading
     */
    public static func request(action: Selector, view: BaseViewController,
                               id: String, isShowLoading: Bool = true) {
        let request = MedicalRecordInfoRequest(
            url: G01Const.PATH_MEDICAL_RECORD_INFO,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(id: id)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute(isShowLoadingView: isShowLoading)
    }
}
