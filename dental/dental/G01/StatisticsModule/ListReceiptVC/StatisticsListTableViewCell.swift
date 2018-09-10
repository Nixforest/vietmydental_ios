//
//  StatisticsListTableViewCell.swift
//  dental
//
//  Created by Lâm Phạm on 8/16/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class StatisticsListTableViewCell: UITableViewCell {

    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbDept: UILabel!
    @IBOutlet weak var lbDiscount: UILabel!
    @IBOutlet weak var lbReceiptionistName: UILabel!
    @IBOutlet weak var lbDoctorName: UILabel!
    @IBOutlet weak var lbCustomerName: UILabel!
    @IBOutlet weak var viewBorder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBorder.drawRadius(6, color: "007BFE".hexColor(), thickness: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadReceipt(_ receipt: ConfigExtBean) {
        for data in receipt.getListData() {
            switch data.id {
            case DomainConst.ITEM_NAME:
                lbCustomerName.text = data.getStringData()
                break
            case DomainConst.ITEM_RECEIPT_TOTAL:
                lbAmount.text = data.getStringData()
                break
            case DomainConst.ITEM_RECEIPT_DEBT:
                lbDept.text = data.getStringData()
                break
            case DomainConst.ITEM_DISCOUNT:
                lbDiscount.text = data.getStringData()
                break
            case DomainConst.ITEM_DOCTOR:
                lbDoctorName.text = "BS \(data.getStringData())"
                break
            case DomainConst.ITEM_RECEIPTIONIST_NAME:
                if data.getStringData().count > 0 {
                    lbReceiptionistName.text = "TN \(data.getStringData())"
                }
                break
            default:
                break
            }
        }
    }
    
     func select(isSelect: Bool) {
        if isSelect {
            contentView.backgroundColor = "007BFE".hexColor()
        } else {
            contentView.backgroundColor = UIColor.white
        }
    }
    
}
