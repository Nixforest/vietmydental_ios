//
//  G01Const.swift
//  dental
//
//  Created by SPJ on 2/2/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01Const: NSObject {
    /** Function identifier */
    public static let FUNC_IDENTIFIER                           = DomainConst.APPNAME + "g01"
    /** Path to connect with PHP server */
    public static let PATH_CUSTOMER_LIST                        = "customer/list"
    /** Path to connect with PHP server */
    public static let PATH_CUSTOMER_INFO                        = "customer/view"
    /** Path to connect with PHP server */
    public static let PATH_MEDICAL_RECORD_INFO                  = "customer/medicalRecordInfo"
    /** Path to connect with PHP server */
    public static let PATH_MEDICAL_RECORD_UPDATE                = "customer/updateMedicalRecord"
    /** Path to connect with PHP server */
    public static let PATH_TREATMENT_LIST                       = "customer/listTreatment"
    /** Path to connect with PHP server */
    public static let PATH_TREATMENT_INFO                       = "customer/treatmentInfo"
    /** Path to connect with PHP server */
    public static let PATH_TREATMENT_UPDATE                     = "customer/updateTreatmentSchedule"
    /** Path to connect with PHP server */
    public static let PATH_TREATMENT_CREATE                     = "customer/createSchedule"
    /** Path to connect with PHP server */
    public static let PATH_TREATMENT_DETAIL_UPDATE              = "customer/updateTreatmentScheduleDetail"
    /** Path to connect with PHP server */
    public static let PATH_TREATMENT_PROCESS_UPDATE             = "customer/updateTreatmentScheduleProcess"
    /** Path to connect with PHP server */
    public static let PATH_TREATMENT_PROCESS_CREATE             = "customer/createTreatmentScheduleProcess"
    /** Path to connect with PHP server */
    public static let PATH_TREATMENT_DETAIL_CREATE              = "customer/createTreatmentScheduleDetail"
    /** Path to connect with PHP server */
    public static let PATH_PATHOLOGICAL_CREATE                  = "default/createPathological"
    /** Path to connect with PHP server */
    public static let PATH_DIAGNOSIS_CREATE                     = "default/createDiagnosis"
}
