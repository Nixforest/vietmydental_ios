//
//  CustomerInfoTableViewCell.swift
//  dental
//
//  Created by Lâm Phạm on 7/31/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class CustomerInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var imgGender: UIImageView!
    @IBOutlet weak var lbAge: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCustomer(_ customer: CustomerBean) {
        lbName.text = customer.name
        lbAge.text = customer.age
        lbAddress.text = customer.address
        if customer.gender != DomainConst.CONTENT00569 {
            imgGender.image = #imageLiteral(resourceName: "ic_female")
        } else {
            imgGender.image = #imageLiteral(resourceName: "ic_male")
        }
//        var path = DomainConst.VMD_PATIENT_ICON_IMG_NAME
//        if customer.gender != DomainConst.CONTENT00569 {
//            path = DomainConst.VMD_PATIENT_FEMALE_ICON_IMG_NAME
//        }
//        imgGender.image = ImageManager.getImage(named: path)
//
    }
    
}
