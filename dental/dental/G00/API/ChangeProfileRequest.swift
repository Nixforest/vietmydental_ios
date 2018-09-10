//
//  ChangeProfileRequest.swift
//  project
//
//  Created by SPJ on 10/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class ChangeProfileRequest: BaseRequest {
    /**
     * Set data content
     * - parameter name:        Name
     * - parameter province:    Province
     * - parameter district:    District
     * - parameter ward:        Ward
     * - parameter street:      Street
     * - parameter houseNumber: House number
     * - parameter email:       Email
     * - parameter agent:       Agent
     */
    func setData(name: String,
                 province: String, district: String, ward: String,
                 street: String, houseNumber: String, email: String,
                 agent: String) {
        self.data = "q=" + String.init(
            format: "{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":%d}",
            DomainConst.KEY_TOKEN,          BaseModel.shared.getUserToken(),
            DomainConst.KEY_NAME,           name,
            DomainConst.KEY_PROVINCE_ID,    province,
            DomainConst.KEY_DISTRICT_ID,    district,
            DomainConst.KEY_WARD_ID,        ward,
            DomainConst.KEY_STREET_ID,      street,
            DomainConst.KEY_HOUSE_NUMBER,   houseNumber,
            DomainConst.KEY_EMAIL,          email,
            DomainConst.KEY_AGENT_ID,       agent,
            DomainConst.KEY_PLATFORM,       DomainConst.PLATFORM_IOS
        )
    }
    
    /**
     * Request generate OTP
     * - parameter action:      Action execute when finish this task
     * - parameter view:        Current view
     * - parameter name:        Name
     * - parameter province:    Province
     * - parameter district:    District
     * - parameter ward:        Ward
     * - parameter street:      Street
     * - parameter houseNumber: House number
     * - parameter email:       Email
     * - parameter agent:       Agent
     */
    public static func request(action: Selector, view: BaseViewController,
                               name: String,
                               province: String, district: String, ward: String,
                               street: String, houseNumber: String, email: String,
                               agent: String) {
        let request = ChangeProfileRequest(
            url: G00Const.PATH_USER_CHANGE_PROFILE,
            reqMethod: DomainConst.HTTP_POST_REQUEST,
            view: view)
        request.setData(name: name,
                        province: province, district: district, ward: ward,
                        street: street, houseNumber: houseNumber, email: email,
                        agent: agent)
        NotificationCenter.default.addObserver(view, selector: action, name:NSNotification.Name(rawValue: request.theClassName), object: nil)
        request.execute()
    }
}
