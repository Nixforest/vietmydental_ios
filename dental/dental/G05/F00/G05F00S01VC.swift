//
//  G05F00S01VC.swift
//  dental
//
//  Created by Lâm Phạm on 11/13/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G05F00S01VC: ChildExtViewController {

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Đăng ký tài khoản")
        logo.image = ImageManager.getImage(named: DomainConst.LOGO_LOGIN_ICON_IMG_NAME)
        btnRegister.drawRadius(6)
        tfPhone.text = "0949207417"
    }

    func register(phone: String) {
        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        let param = CustomerLoginRequest()
        param.phone = phone
        serviceInstance.customerLogin(param: param, success: { (resp) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            let vc = G05F00S02VC(phone: self.tfPhone.text!)
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.showAlert(message: error.message)
        }
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        if (tfPhone.text?.count)! < 10 {
            self.showAlert(message: "Vui lòng nhập số điện thoại hợp lệ")
            return
        }
        BaseModel.shared.sharedString = tfPhone.text!
        register(phone: tfPhone.text!)
    }
    

}
