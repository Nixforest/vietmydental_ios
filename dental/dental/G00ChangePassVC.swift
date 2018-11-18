//
//  G00ChangePassVC.swift
//  dental
//
//  Created by Lâm Phạm on 10/24/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G00ChangePassVC: ChildExtViewController {

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tfConfirm: UITextField!
    @IBOutlet weak var tfOldPass: UITextField!
    @IBOutlet weak var tfNewPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Cập nhật mật khẩu")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Services
    func changePass(oldPass: String, newPass: String) {
        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        let para = ChangePassRequest()
        para.new_password = newPass
        para.old_password = oldPass
        serviceInstance.changePassword(para: para, success: { (resp) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.showAlert(message: resp.message, okHandler: { (action) in
                self.backButtonTapped(self)
            })
        }) { (error) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.showAlert(message: error.message)
        }
    }

    @IBAction func btnSaveAction(_ sender: Any) {
        if tfOldPass.text?.length == 0 {
            self.showAlert(message: "Vui lòng nhập mật khẩu cũ") { (action) in
                self.tfOldPass.becomeFirstResponder()
            }
            return
        }
        if tfNewPass.text?.length == 0 {
            self.showAlert(message: "Vui lòng nhập mật khẩu mới") { (action) in
                self.tfNewPass.becomeFirstResponder()
            }
            return
        }
        if tfConfirm.text != tfNewPass.text {
            self.showAlert(message: "Mật khẩu xác nhận không trùng khớp") { (action) in
                self.tfConfirm.becomeFirstResponder()
            }
            return
        }
        changePass(oldPass: tfOldPass.text!, newPass: tfNewPass.text!)
    }
}








