//
//  UpdateMedicalRecord.swift
//  dental
//
//  Created by Lâm Phạm on 1/16/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit

class UpdateMedicalRecord: MasterModel {
    var status = 0
    var code = 0
    var message = ""
}

class UpdateMedicalRecord_Request: MasterModel {
    var id = ""
    var record_number = ""
    var medical_history = [""]
}


extension Service {
    func updateMedicalRecord(param: UpdateMedicalRecord_Request, success: @escaping((UpdateMedicalRecord) -> Void), failure: @escaping((APIResponse) -> Void)) {
        serviceInstance.request(api: .updateMedicalRecord, method: .post, parameter: param.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            let result = UpdateMedicalRecord()
            result.code = response.code
            result.message = response.message
            result.status = response.status
            success(result)
        }) { (error) in
            failure(error)
        }
    }
}








