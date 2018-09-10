//
//  CustomerInfoHeaderView.swift
//  dental
//
//  Created by Lâm Phạm on 1/14/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

protocol CustomerInfoHeaderViewDelegate: class {
//    func CustomerInfoHeaderViewDidSelect(object: MasterObject)
    func customerInfoHeaderViewDidSelect(object: ConfigExtBean)
}

class CustomerInfoHeaderView: GreenView {

    @IBOutlet weak var btActionTrailing: NSLayoutConstraint!
    @IBOutlet weak var lbHeaderLeading: NSLayoutConstraint!
    @IBOutlet weak var lbHeader: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    
    var delegate: CustomerInfoHeaderViewDelegate!
//    var object: MasterObject!
    var object: ConfigExtBean!
    
    override func initStyle() {
        self.backgroundColor = UIColor.white
        if isIpad {
            let scrW = UIScreen.main.bounds.width
            lbHeaderLeading.constant = scrW/3
            btActionTrailing.constant = scrW/3
        }
    }
    
//    func setHeader(object: MasterObject) {
//        self.object = object
//        self.lbHeader.text = object.name
//    }
    
    func setHeader(bean: ConfigExtBean,
                   actionText: String = DomainConst.CONTENT00125) {
        self.object = bean
        self.lbHeader.text = " " + bean.name.uppercased()
        self.lbHeader.font = GlobalConst.BASE_BOLD_FONT
        self.btnAction.setTitle(actionText, for: UIControlState())
    }

    @IBAction func seeMoreAction(_ sender: Any) {
        delegate.customerInfoHeaderViewDidSelect(object: self.object)
    }
}
