//
//  G05F00S02VC.swift
//  dental
//
//  Created by Lâm Phạm on 11/14/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G05F00S02VC: ChildExtViewController {

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var tfOTP: UITextField!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var btnRewrite: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    
    var phone: String = ""
    
    init(phone: String) {
        super.init(nibName: "G05F00S02VC", bundle: Bundle.main)
        self.phone = phone
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Nhập mã OTP")
        logo.image = ImageManager.getImage(named: DomainConst.LOGO_LOGIN_ICON_IMG_NAME)
        btnRegister.drawRadius(4)
        btnRewrite.drawRadius(4)
        btnResend.drawRadius(4)
        lbPhone.text = phone
    }
    
    //MARK: - Service
    func login(otp: String) {
        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        let param = LoginCustomerConfirmRequest()
        param.phone = phone
        param.otp = otp
        param.apns_device_token = ""
        serviceInstance.loginCustomerConfirm(param: param, success: { (loginBean) in
            app.isCustomer = true
            BaseModel.shared.loginSuccess(loginBean.data.token)
            LoginRespBean.saveConfigData(data: loginBean)
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.showAlert(message: error.message)
        }
    }

    
    //MARK: - IBAction
    @IBAction func resendOTPAction(_ sender: Any) {
        
    }
    
    @IBAction func rewritePhoneAction(_ sender: Any) {
        
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        if BaseModel.shared.checkTrainningMode() {
            login(otp: "1111")
            return
        }
        if (tfOTP.text?.count)! != 4 {
            self.showAlert(message: "Vui lòng nhập mã OTP hợp lệ")
            return
        }
        login(otp: tfOTP.text!)
    }

}
