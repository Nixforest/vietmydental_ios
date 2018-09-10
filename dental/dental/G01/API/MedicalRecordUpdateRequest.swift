//
//  MedicalRecordUpdateRequest.swift
//  dental
//  P0010_UpdateMedicalRecord_API
//  Created by SPJ on 2/16/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class MedicalRecordUpdateRequest: BaseRequest {
    /**
     * Set data content
     * - parameter id:              Customer id
     * - parameter recordNumber:    Record number
     * - parameter medicalHistory:  Medical history
     */
    func setData(id: String, recordNumber: String,
                 medicalHistory: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%@,\"%@\":%d}",
            DomainConst.KEY_TOKEN,              BaseModel.shared.getUserToken(),
            DomainConst.KEY_ID,                 id,
            DomainConst.KEY_RECORD_NUMBER,      recordNumber,
            DomainConst.KEY_MEDICAL_HISTORY,    medicalHistory,
            DomainConst.KEY_PLATFORM,           DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request
     * - parameter action:          Action execute when finish this task
     * - parameter view:            Current view
     * - parameter id:              Customer id
     * - parameter recordNumber:    Record number
     * - parameter medicalHistory:  Medical history
     * - parameter isShowLoading:   Flag show loading
     */
    public static func request(action: Selector, view: BaseViewController,
                               id: String, recordNumber: String,
                               medicalHistory: String, isShowLoading: Bool = true) {
        let request = MedicalRecordUpdateRequest(
            url: G01Const.PATH_MEDICAL_RECORD_UPDATE,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(id: id, recordNumber: recordNumber,
                        medicalHistory: medicalHistory)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute(isShowLoadingView: isShowLoading)
    }
}
