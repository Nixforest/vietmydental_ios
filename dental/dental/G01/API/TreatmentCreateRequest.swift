//
//  TreatmentCreateRequest.swift
//  dental
//  P0009_CreateSchedule_API
//  Created by SPJ on 2/18/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class TreatmentCreateRequest: BaseRequest {
    /**
     * Set data content
     * - parameter customer_id:     Customer id
     * - parameter time:            Time
     * - parameter date:            Date
     * - parameter doctor_id:       Doctor id
     * - parameter type:            Type
     * - parameter note:            Working detail
     */
    func setData(customer_id: String,
                 time: String,
                 date: String,
                 doctor_id: String,
                 type: String,
                 note: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,              BaseModel.shared.getUserToken(),
            DomainConst.KEY_CUSTOMER_ID,        customer_id,
            DomainConst.KEY_TIME,               time,
            DomainConst.KEY_DATE,               date,
            DomainConst.KEY_DOCTOR_ID,          doctor_id,
            DomainConst.KEY_TYPE,               type,
            DomainConst.KEY_NOTE,               note,
            DomainConst.KEY_PLATFORM,           DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request
     * - parameter action:          Action execute when finish this task
     * - parameter view:            Current view
     * - parameter customer_id:     Customer id
     * - parameter time:            Time
     * - parameter datr:            Date (format: yyyy/MM/dd)
     * - parameter doctor_id:       Doctor id
     * - parameter type:            Type
     * - parameter note:            Working detail
     */
    public static func request(action: Selector, view: BaseViewController,
                               customer_id: String,
                               time: String,
                               date: String,
                               doctor_id: String,
                               type: String,
                               note: String) {
        let request = TreatmentCreateRequest(
            url: G01Const.PATH_TREATMENT_CREATE,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(customer_id: customer_id,
                        time: time,
                        date: date,
                        doctor_id: doctor_id,
                        type: type,
                        note: note)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
