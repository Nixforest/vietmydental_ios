//
//  DiscountListTableViewCell.swift
//  dental
//
//  Created by Lâm Phạm on 8/9/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit

class DiscountListTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var lbDoctorName: UILabel!
    @IBOutlet weak var lbQuantity: UILabel!
    @IBOutlet weak var lbTreatmentName: UILabel!
    @IBOutlet weak var lbPercent: UILabel!
    @IBOutlet weak var lbCustomerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
