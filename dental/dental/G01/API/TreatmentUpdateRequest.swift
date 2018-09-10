//
//  TreatmentUpdateRequest.swift
//  dental
//  P0011_UpdateTreatmentSchedule_API
//  Created by SPJ on 2/18/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class TreatmentUpdateRequest: BaseRequest {
    /**
     * Set data content
     * - parameter id:              treatment id
     * - parameter diagnosis:       Diagnosis id
     * - parameter pathological:    Pathological id
     * - parameter healthy:         Healthy
     * - parameter status:          Status
     */
    func setData(id: String, diagnosis: String,
                 pathological: String, healthy: String,
                 status: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%@,\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,              BaseModel.shared.getUserToken(),
            DomainConst.KEY_ID,                 id,
            DomainConst.KEY_DIAGNOSIS_ID,       diagnosis,
            DomainConst.KEY_PATHOLOGICAL_ID,    pathological,
            DomainConst.KEY_HEALTHY,            healthy,
            DomainConst.KEY_STATUS,             status,
            DomainConst.KEY_PLATFORM,           DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request
     * - parameter action:          Action execute when finish this task
     * - parameter view:            Current view
     * - parameter id:              Treatment id
     * - parameter diagnosis:       Diagnosis id
     * - parameter pathological:    Pathological id
     * - parameter healthy:         Healthy
     * - parameter status:          Status
     * - parameter isShowLoading:   Flag show loading
     */
    public static func request(action: Selector, view: BaseViewController,
                               id: String, diagnosis: String,
                               pathological: String, healthy: String,
                               status: String, isShowLoading: Bool = true) {
        let request = TreatmentUpdateRequest(
            url: G01Const.PATH_TREATMENT_UPDATE,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(id: id, diagnosis: diagnosis,
                        pathological: pathological, healthy: healthy,
                        status: status)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute(isShowLoadingView: isShowLoading)
    }
}
