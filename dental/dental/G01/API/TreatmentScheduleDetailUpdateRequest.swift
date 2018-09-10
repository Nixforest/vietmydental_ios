//
//  TreatmentScheduleDetailUpdateRequest.swift
//  dental
//  P0013_UpdateTreatmentScheduleDetail_API
//  Created by SPJ on 2/20/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class TreatmentScheduleDetailUpdateRequest: BaseRequest {
    /**
     * Set data content
     * - parameter id:              Treatment id
     * - parameter teeth_id:        Teeth id
     * - parameter teeth_info:      Teeth info
     * - parameter diagnosis:       Diagnosis id
     * - parameter treatment:       Treatment type id
     * - parameter status:          Status
     */
    func setData(id: String,
                 teeth_id: String, teeth_info: String,
                 diagnosis: String,
                 treatment: String,
                 status: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%@,\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,              BaseModel.shared.getUserToken(),
            DomainConst.KEY_ID,                 id,
            DomainConst.KEY_TEETH_ID,           teeth_id,
            DomainConst.KEY_TEETH_INFO,         teeth_info,
            DomainConst.KEY_DIAGNOSIS_ID,       diagnosis,
            DomainConst.KEY_TREATMENT_TYPE_ID,  treatment,
            DomainConst.KEY_STATUS,             status,
            DomainConst.KEY_PLATFORM,           DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request
     * - parameter action:          Action execute when finish this task
     * - parameter view:            Current view
     * - parameter id:              Treatment id
     * - parameter teeth_id:        Teeth id
     * - parameter teeth_info:      Teeth info
     * - parameter diagnosis:       Diagnosis id
     * - parameter treatment:       Treatment type id
     * - parameter status:          Status
     * - parameter isShowLoading:   Flag show loading
     */
    public static func request(action: Selector, view: BaseViewController,
                               id: String,
                               teeth_id: String, teeth_info: String,
                               diagnosis: String,
                               treatment: String,
                               status: String, isShowLoading: Bool = true) {
        let request = TreatmentScheduleDetailUpdateRequest(
            url: G01Const.PATH_TREATMENT_DETAIL_UPDATE,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(id: id,
                        teeth_id: teeth_id, teeth_info: teeth_info,
                        diagnosis: diagnosis,
                        treatment: treatment,
                        status: status)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute(isShowLoadingView: isShowLoading)
    }
}
