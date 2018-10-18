//
//  G04F00S01VC.swift
//  dental
//
//  Created by Lâm Phạm on 10/16/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G04F00S01VC: BaseParentViewController {

    @IBOutlet weak var qrcodeView: QRCodeMainView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createNavigationBar(title: "QRCode")
        qrcodeView.delegate = self
        getUserByQRCode("123")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Service
    func getUserByQRCode(_ code: String) {
        let param = GetCustomerByQRCodeRequest()
        param.qr = code
        serviceInstance.getCustomerByQRCode(param: param, success: { (response) in
            
        }) { (error) in
            self.showAlert(message: error.message)
        }
    }
}

extension G04F00S01VC: QRCodeMainViewDelegate {
    func qRCodeMainViewDidSelectScan() {
        
    }
    func qRCodeMainViewDidSelectHistory() {
    
    }
    func qRCodeMainViewDidSelectOK(code: String) {
        if code.count == 0 {
            self.showAlert(message: "Vui lòng điền code cần tìm kiếm")
            return
        }
        
    }
}











