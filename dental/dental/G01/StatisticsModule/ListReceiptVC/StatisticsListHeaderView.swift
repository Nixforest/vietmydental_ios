//
//  StatisticsListHeaderView.swift
//  dental
//
//  Created by Lâm Phạm on 8/16/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class StatisticsListHeaderView: BaseView {

    @IBOutlet weak var lbCustomerName: UILabel!
    @IBOutlet weak var lbReceiptionistName: UILabel!
    @IBOutlet weak var lbDoctorName: UILabel!
    @IBOutlet weak var lbDebt: UILabel!
    @IBOutlet weak var lbDiscount: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var lbTreatmentName: UILabel!
    @IBOutlet weak var lbQuantity: UILabel!
    
    override func firstInit() {
        self.backgroundColor = "f8f8f8".hexColor()
    }

    func loadReceipt(_ receipt: ConfigExtBean) {
        for data in receipt.getListData() {
            switch data.id {
            case DomainConst.ITEM_NAME:
                lbCustomerName.text = data.getStringData()
                break
            case DomainConst.ITEM_TOTAL:
                lbTotal.text = data.getStringData()
                break
            case DomainConst.ITEM_RECEIPT_DEBT:
                lbDebt.text = data.getStringData()
                break
            case DomainConst.ITEM_DISCOUNT:
                lbDiscount.text = data.getStringData()
                break
            case DomainConst.ITEM_DOCTOR:
                lbDoctorName.text = "\(data.getStringData())"
                break
            case DomainConst.ITEM_RECEIPTIONIST_NAME:
                lbReceiptionistName.text = "\(data.getStringData())"
                break
            case DomainConst.ITEM_QUANTITY:
                lbQuantity.text = data.getStringData().count > 0 ? "x\(data.getStringData())" : ""
                break
            case DomainConst.ITEM_TREATMENT:
                lbTreatmentName.text = data.getStringData()
                break
            default:
                break
            }
        }
    }
}











