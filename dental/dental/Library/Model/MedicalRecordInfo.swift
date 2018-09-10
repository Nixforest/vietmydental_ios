//
//  MedicalRecordInfo.swift
//  dental
//
//  Created by Lâm Phạm on 1/15/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit

class MedicalRecordInfoUnit: MasterModel {
    var title = ""
    var desc = ""
}

class MedicalRecordInfo: MasterModel {
    var id: String = "1"
    var name: String = "Nguyễn Văn A"
    var gender: String = "Nam"
    var age: String = "25t"
    var phone: String = "0123456789"
    var address: String = "23 Nguyễn Thị Thập Q7 Tp HCM"
    var birthday: String = "01/01/1990"
    var email: String = "namnv@mpp.vn"
    var agent: String = "Chi nhánh quận 7"
    var career: String = "Giáo viên"
    var characteristics: String = "Răng hô"
    var record_number: String = "123123"
    var medical_history: [NSDictionary] = []
    var medical_history_Model: [MasterObject] = []
    
    //offline variable
    var listInfo: [MasterObject] = []
    var isSelected: Bool = false
    
}
class MedicalRecordInfo_Request: MasterModel {
    var id = ""
}

extension Service {
    func getMedicalRecordInfo(param: MedicalRecordInfo_Request,  success: @escaping ((MedicalRecordInfo)->Void), failure: @escaping ((APIResponse)->Void)) {
        serviceInstance.request(api: .getMedicalRecordInfo, method: .post, parameter: param.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            let record = MedicalRecordInfo.init(dictionary: response.data as! NSDictionary)
            record.medical_history_Model = MasterObject.listed(dicts: record.medical_history)
            let dict = response.data as! NSDictionary
            for i in 0..<dict.allKeys.count {
                let unit = MasterObject()
                if let title = dict.allKeys[i] as? String {
                    unit.name = title
                }
                if let desc = dict.allValues[i] as? String {
                    unit.desc = desc
                }
                record.listInfo.append(unit)
            }
            success(record)
        }) { (error) in
            failure(error)
        }
    }
}



















