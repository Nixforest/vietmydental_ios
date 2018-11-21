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
    
    func toCustomerScreen(id: String) {
    }
    
    //MARK: - Service
    func getUserByQRCode(_ code: String) {
        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        let param = GetCustomerByQRCodeRequest()
        param.qr = code
        serviceInstance.getCustomerByQRCode(param: param, success: { (response) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            let vc = G01F00S02VC(nibName: G01F00S02VC.theClassName, bundle: nil)
            vc.setId(id: response.customerID, code: code)
            vc.shouldSaveCustomer = true
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.showAlert(message: error.message)
        }
    }
}

extension G04F00S01VC: QRCodeMainViewDelegate {
    func qRCodeMainViewDidSelectScan() {
        let vc = G04F01S01VC()
        vc.didGetCode { (code) in
            self.qrcodeView.setCode(code)
            self.qRCodeMainViewDidSelectOK(code: code)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func qRCodeMainViewDidSelectHistory() {
        let vc = G04F00S02VC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func qRCodeMainViewDidSelectOK(code: String) {
        if code.count == 0 {
            self.showAlert(message: "Vui lòng điền code cần tìm kiếm")
            return
        }
        self.getUserByQRCode(code)
    }
}










