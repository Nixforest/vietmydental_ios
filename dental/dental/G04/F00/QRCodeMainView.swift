//
//  QRCodeMainView.swift
//  dental
//
//  Created by Lâm Phạm on 10/16/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

protocol QRCodeMainViewDelegate: class {
    func qRCodeMainViewDidSelectScan()
    func qRCodeMainViewDidSelectHistory()
    func qRCodeMainViewDidSelectOK(code: String)
}

class QRCodeMainView: BaseView {

    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var tfCode: UITextField!
    
    var delegate: QRCodeMainViewDelegate!
    
    override func firstInit() {
        btnOK.drawRadius(4)
        btnHistory.drawRadius(4, color: GlobalConst.MAIN_COLOR_GAS_24H, thickness: 0.5)
    }
    /** set code to textField */
    func setCode(_ code: String) {
        tfCode.text = code
    }

    @IBAction func btnScanAction(_ sender: Any) {
        delegate.qRCodeMainViewDidSelectScan()
    }
    @IBAction func btnOKAction(_ sender: Any) {
        delegate.qRCodeMainViewDidSelectOK(code: tfCode.text!)
    }
    @IBAction func btnHistoryAction(_ sender: Any) {
        delegate.qRCodeMainViewDidSelectHistory()
    }
}












