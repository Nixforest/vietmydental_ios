//
//  CustomerHomeView.swift
//  dental
//
//  Created by Lâm Phạm on 11/18/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

protocol CustomerHomeViewDelegate: class {
    func customerHomeViewDidSelectBooking()
    func customerHomeViewDidSelectMedicalRecord()
}

class CustomerHomeView: BaseView {

    @IBOutlet weak var btnBooking: UIButton!
    @IBOutlet weak var btnRecord: UIButton!
    
    var delegate: CustomerHomeViewDelegate!
    
    override func firstInit() {
        btnBooking.drawRadius(6)
        btnRecord.drawRadius(6)
        if LoginBean.shared.customer_id.count == 0 {
            btnRecord.alpha = 0
        }
    }

    @IBAction func btnBookingAction(_ sender: Any) {
        delegate.customerHomeViewDidSelectBooking()
    }
    @IBAction func btnRecordAction(_ sender: Any) {
        delegate.customerHomeViewDidSelectMedicalRecord()
    }
}






