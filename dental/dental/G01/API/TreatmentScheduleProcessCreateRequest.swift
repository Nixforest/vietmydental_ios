//
//  TreatmentScheduleProcessCreateRequest.swift
//  dental
//  P0014_CreateTreatmentScheduleProcess_API
//  Created by SPJ on 2/21/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class TreatmentScheduleProcessCreateRequest: BaseRequest {
    /**
     * Set data content
     * - parameter id:              Treatment detail id
     * - parameter date:            Process date
     * - parameter teeth_id:        Teeth id
     * - parameter name:            Name of work
     * - parameter content:         Detail of work
     * - parameter note:            Note of doctor
     */
    func setData(id: String,
                 date: String,
                 teeth_id: String,
                 name: String,
                 content: String,
                 note: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,              BaseModel.shared.getUserToken(),
            DomainConst.KEY_DETAIL_ID,          id,
            DomainConst.KEY_DATE,               date,
            DomainConst.KEY_TEETH_ID,           teeth_id,
            DomainConst.KEY_NAME,               name,
            DomainConst.KEY_CONTENT,            content,
            DomainConst.KEY_NOTE,               note,
            DomainConst.KEY_PLATFORM,           DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request
     * - parameter action:          Action execute when finish this task
     * - parameter view:            Current view
     * - parameter id:              Treatment detail id
     * - parameter date:            Process date
     * - parameter teeth_id:        Teeth id
     * - parameter name:            Name of work
     * - parameter content:         Detail of work
     * - parameter note:            Note of doctor
     * - parameter isShowLoading:   Flag show loading
     */
    public static func request(action: Selector, view: BaseViewController,
                               id: String,
                               date: String,
                               teeth_id: String,
                               name: String,
                               content: String,
                               note: String, isShowLoading: Bool = true) {
        let request = TreatmentScheduleProcessCreateRequest(
            url: G01Const.PATH_TREATMENT_PROCESS_CREATE,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(id: id,
                        date: date,
                        teeth_id: teeth_id,
                        name: name,
                        content: content,
                        note: note)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute(isShowLoadingView: isShowLoading)
    }
}
