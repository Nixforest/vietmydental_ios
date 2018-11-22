//
//  G00LoginExtVC.swift
//  project
//
//  Created by SPJ on 9/15/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G00LoginExtVC: ParentExtViewController {
    // MARK: Properties
    /** Logo */
    var imgLogo:        UIImageView = UIImageView()
    /** Login label */
    var lblLogin:       UILabel     = UILabel()
    /** Phone textfield */
    var txtPhone:       UITextField = UITextField()
    /** Password textfield */
    var txtPassword:    UITextField = UITextField()
    /** Button next */
    var btnNext:        UIButton    = UIButton(type: .custom)
    /** Label OR */
    var lblOr:          UILabel     = UILabel()
    /** Button facebook */
    var btnFacebook:    UIButton    = UIButton()
    /** Button Zalo */
    var btnZalo:        CustomButton    = CustomButton(type: .custom)
    //++ BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
    /** Label Support */
    var lblSupport:     UILabel     = UILabel()
    /** Label Hotline */
    var lblHotline:     UILabel     = UILabel()
    //-- BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
    /** Tap counter on logo */
    var imgLogoTappedCounter:Int        = 0
    /** Phone value */
    var phone:          String          = DomainConst.BLANK
    /** Token value */
    var token:          String          = DomainConst.BLANK
    
    // MARK: Constant
    // Logo
    var LOGIN_LOGO_REAL_WIDTH_HD        = GlobalConst.LOGIN_LOGO_WIDTH * G00LoginExtVC.W_RATE_HD
    var LOGIN_LOGO_REAL_HEIGHT_HD       = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_HD
    var LOGIN_LOGO_REAL_Y_POS_HD        = GlobalConst.LOGIN_LOGO_Y_POS * G00LoginExtVC.H_RATE_HD
    
    var LOGIN_LOGO_REAL_WIDTH_FHD       = GlobalConst.LOGIN_LOGO_WIDTH * G00LoginExtVC.W_RATE_FHD
    var LOGIN_LOGO_REAL_HEIGHT_FHD      = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_FHD
    var LOGIN_LOGO_REAL_Y_POS_FHD       = GlobalConst.LOGIN_LOGO_Y_POS_FHD * G00LoginExtVC.H_RATE_FHD
    
    var LOGIN_LOGO_REAL_WIDTH_FHD_L     = GlobalConst.LOGIN_LOGO_WIDTH * G00LoginExtVC.W_RATE_FHD_L
    var LOGIN_LOGO_REAL_HEIGHT_FHD_L    = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_FHD_L
    var LOGIN_LOGO_REAL_Y_POS_FHD_L     = GlobalConst.LOGIN_LOGO_Y_POS_FHD_LAND * G00LoginExtVC.H_RATE_FHD_L
    
    // Phone
    var LOGIN_PHONE_REAL_WIDTH_HD       = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_HD
    var LOGIN_PHONE_REAL_HEIGHT_HD      = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_HD
    var LOGIN_PHONE_REAL_WIDTH_FHD      = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_FHD
    var LOGIN_PHONE_REAL_HEIGHT_FHD     = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_FHD
    var LOGIN_PHONE_REAL_WIDTH_FHD_L    = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_FHD_L
    var LOGIN_PHONE_REAL_HEIGHT_FHD_L   = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_FHD_L
    // Next button
    var LOGIN_NEXT_BUTTON_REAL_SIZE_HD      = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * G00LoginExtVC.H_RATE_HD
    var LOGIN_NEXT_BUTTON_REAL_SIZE_FHD     = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * G00LoginExtVC.H_RATE_FHD
    var LOGIN_NEXT_BUTTON_REAL_SIZE_FHD_L   = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * G00LoginExtVC.H_RATE_FHD_L
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "")
        setLocalData()
        self.view.makeComponentsColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    /**
     * Handle update constants
     */
    override func updateConst() {
        // Login
        LOGIN_LOGO_REAL_WIDTH_HD        = GlobalConst.LOGIN_LOGO_WIDTH * G00LoginExtVC.W_RATE_HD
        LOGIN_LOGO_REAL_HEIGHT_HD       = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_HD
        LOGIN_LOGO_REAL_Y_POS_HD        = GlobalConst.LOGIN_LOGO_Y_POS * G00LoginExtVC.H_RATE_HD
        
        LOGIN_LOGO_REAL_WIDTH_FHD       = GlobalConst.LOGIN_LOGO_WIDTH * G00LoginExtVC.W_RATE_FHD
        LOGIN_LOGO_REAL_HEIGHT_FHD      = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_FHD
        LOGIN_LOGO_REAL_Y_POS_FHD       = GlobalConst.LOGIN_LOGO_Y_POS_FHD * G00LoginExtVC.H_RATE_FHD
        
        LOGIN_LOGO_REAL_WIDTH_FHD_L     = GlobalConst.LOGIN_LOGO_WIDTH * G00LoginExtVC.W_RATE_FHD_L
        LOGIN_LOGO_REAL_HEIGHT_FHD_L    = GlobalConst.LOGIN_LOGO_HEIGHT * G00LoginExtVC.H_RATE_FHD_L
        LOGIN_LOGO_REAL_Y_POS_FHD_L     = GlobalConst.LOGIN_LOGO_Y_POS_FHD_LAND * G00LoginExtVC.H_RATE_FHD_L
        
        // Phone
        LOGIN_PHONE_REAL_WIDTH_HD       = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_HD
        LOGIN_PHONE_REAL_HEIGHT_HD      = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_HD
        
        LOGIN_PHONE_REAL_WIDTH_FHD      = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_FHD
        LOGIN_PHONE_REAL_HEIGHT_FHD     = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_FHD
        
        LOGIN_PHONE_REAL_WIDTH_FHD_L    = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_FHD_L
        LOGIN_PHONE_REAL_HEIGHT_FHD_L   = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_FHD_L
        
        // Next button
        LOGIN_NEXT_BUTTON_REAL_SIZE_HD      = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * G00LoginExtVC.H_RATE_HD
        LOGIN_NEXT_BUTTON_REAL_SIZE_FHD     = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * G00LoginExtVC.H_RATE_FHD
        LOGIN_NEXT_BUTTON_REAL_SIZE_FHD_L   = GlobalConst.LOGIN_NEXT_BUTTON_SIZE * G00LoginExtVC.H_RATE_FHD_L
    }
    
    /**
     * Handle set background image
     */
    //    override func setBackgroundImage() {
    //        switch UIDevice.current.userInterfaceIdiom {
    //        case .phone:
    //            self.updateBackground(bkg: DomainConst.LOGIN_BKG_IPHONE_IMG_NAME)
    //            break
    //        case .pad:
    //            switch UIApplication.shared.statusBarOrientation {
    //            case .portrait, .portraitUpsideDown:
    //                self.updateBackground(bkg: DomainConst.LOGIN_BKG_IPAD_IMG_NAME)
    //            case .landscapeLeft, .landscapeRight:
    //                self.updateBackground(bkg: DomainConst.LOGIN_BKG_IPAD_LANDSCAPE_IMG_NAME)
    //            default:
    //                self.updateBackground(bkg: DomainConst.LOGIN_BKG_IPAD_IMG_NAME)
    //            }
    //            break
    //        default:
    //            self.setBackground(bkg: DomainConst.LOGIN_BKG_IPAD_IMG_NAME)
    //        }
    //    }
    
    /**
     * Create children views
     */
    override func createChildrenViews() {
        super.createChildrenViews()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            self.createLogoImgHD()
            self.createLoginLabel()
            self.createPhoneTextFieldHD()
            //            self.createNextBtnHD()
            self.createPasswordTextFieldHD()
            self.createORLabel()
            self.createFBBtnHD()
            self.createZLBtnHD()
            self.createHotlineLabelHD()
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                self.createLogoImgFHD()
                self.createLoginLabel()
                self.createPhoneTextFieldFHD()
                //                self.createNextBtnFHD()
                self.createPasswordTextFieldFHD()
                self.createORLabel()
                self.createFBBtnFHD()
                self.createZLBtnFHD()
                //++ BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
                self.createHotlineLabelFHD()
            //-- BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
            case .landscapeLeft, .landscapeRight:       // Landscape
                self.createLogoImgFHD_L()
                self.createLoginLabel()
                self.createPhoneTextFieldFHD_L()
                //                self.createNextBtnFHD_L()
                self.createPasswordTextFieldFHD_L()
                self.createORLabel()
                self.createFBBtnFHD_L()
                self.createZLBtnFHD_L()
                //++ BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
                self.createHotlineLabelFHD_L()
            //-- BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
            default:
                break
            }
            
            break
        default:
            break
        }
        //++ BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
        self.createSupportLabel()
        //-- BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
        
        self.view.addSubview(imgLogo)
        self.view.addSubview(lblLogin)
        self.view.addSubview(txtPhone)
        self.view.addSubview(txtPassword)
        //        self.view.addSubview(lblOr)
        self.view.addSubview(btnFacebook)
        //        self.view.addSubview(btnZalo)
        
        //++ BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
        //        self.view.addSubview(lblHotline)
        //        self.view.addSubview(lblSupport)
        //-- BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
    }
    
    /**
     * Update children views
     */
    override func updateChildrenViews() {
        super.updateChildrenViews()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            self.createLogoImgHD()
            self.updateLoginLabel()
            self.updatePhoneTextFieldHD()
            self.updatePasswordTextFieldHD()
            self.updateORLabel()
            self.updateFBBtnHD()
            self.updateZLBtnHD()
            //++ BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
            self.updateHotlineLabelHD()
            //-- BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                self.createLogoImgFHD()
                self.updateLoginLabel()
                self.updatePhoneTextFieldFHD()
                self.updatePasswordTextFieldFHD()
                self.updateORLabel()
                self.updateFBBtnFHD()
                self.updateZLBtnFHD()
                //++ BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
                self.updateHotlineLabelFHD()
            //-- BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
            case .landscapeLeft, .landscapeRight:       // Landscape
                self.createLogoImgFHD_L()
                self.updateLoginLabel()
                self.updatePhoneTextFieldFHD_L()
                self.updatePasswordTextFieldFHD_L()
                self.updateORLabel()
                self.updateFBBtnFHD_L()
                self.updateZLBtnFHD_L()
                //++ BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
                self.updateHotlineLabelFHD_L()
            //-- BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
            default:
                break
            }
            
            break
        default:
            break
        }
        //++ BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
        self.updateSupportLabel()
        //-- BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
    }
    
    // MARK: Event handler
    /**
     * Handle when tap on next button
     */
    func btnNextTapped(_ sender: AnyObject) {
        // Get value from text field
        if let phoneValue = txtPhone.text {
            // Check if value is empty or not
            if !phoneValue.isEmpty {
                // Hide keyboard
                self.view.endEditing(true)
                // Save static data
                self.phone = phoneValue
                // Save current phone
                BaseModel.shared.setCurrentUsername(username: phoneValue)
                
                return
            }
        }
        showAlert(message: DomainConst.CONTENT00030)
    }
    
    /**
     * Handle when finish open confirm screen
     */
    internal func finishOpenConfirm() -> Void {
        print("finishOpenConfirm")
    }
    
    /**
     * Handle when finish dismiss login screen
     */
    internal func finishDismissLogin() -> Void {
        //        print("finishDismissLogin")
        //        let confirmCode = G00ConfirmCodeVC(nibName: G00ConfirmCodeVC.theClassName, bundle: nil)
        //        confirmCode.setData(phone: self.phone, token: self.token)
        //        if let controller = BaseViewController.getCurrentViewController() {
        //            controller.present(confirmCode, animated: true, completion: finishOpenConfirm)
        //        }
    }
    
    /**
     * Handle when finish request generate otp code
     */
    internal func finishRequestGenerateOTP(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            self.token = model.token
            // Hide login view
            self.dismiss(animated: true, completion: finishDismissLogin)
        } else {
            showAlert(message: model.message)
        }
    }
    
    /**
     * Handle when tap on facebook button
     */
    func btnFacebookTapped(_ sender: AnyObject) {
        //++ BUG0157-SPJ (NguyenPT 20171004) Use facebook framework
        //        let loginManager = LoginManager()
        //        loginManager.logIn([.publicProfile, .email],
        //                           viewController: self,
        //                           completion: {
        //                            loginResult in
        //                            switch loginResult {
        //                            case .failed(let error):
        //                                self.showAlert(message: error.localizedDescription)
        //                                break
        //                            case .cancelled:
        //                                self.showAlert(message: DomainConst.CONTENT00511)
        //                                break
        //                                case .success(grantedPermissions: _,
        //                                              declinedPermissions: _,
        //                                              token: _):
        //                                    self.getDataFromFacebook()
        //                                break
        //                            }
        //        })
        //-- BUG0157-SPJ (NguyenPT 20171004) Use facebook framework
        if ((txtPhone.text?.isEmpty)! || (txtPassword.text?.isEmpty)!) {
            showAlert(message: DomainConst.CONTENT00023)
        } else {
            if let username = txtPhone.text {
                BaseModel.shared.setCurrentUsername(username: username)
                // Check if username account is appletest
                if username.lowercased() == "appletest" {
                    if !BaseModel.shared.checkTrainningMode() {
                        BaseModel.shared.setTrainningMode(true)
                    }
                }
                LoginRequest.requestLogin(
                    action: #selector(finishLoginRequest(_:)),
                    view: self,
                    username: username,
                    password: txtPassword.text!)
            }
            
        }
    }
    
    func finishLoginRequest(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = LoginRespBean(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.loginSuccess(model.data.token)
            //            BaseModel.shared.saveTempData(loginModel: model)
            //            BaseModel.shared.setListMenu(listMenu: model.data.menu)
            LoginRespBean.saveConfigData(data: model)
            self.dismiss(animated: true, completion: finishDismissLogin)
            NotificationCenter.default.post(name: NSNotification.Name.init("HOMEVC_SHOULD_RELOAD_LOGIC"), object: nil)
        } else {
            showAlert(message: model.message)
        }
    }
    
    /**
     * Handle when tap on zalo button
     */
    func btnZaloTapped(_ sender: AnyObject) {
        showAlert(message: DomainConst.CONTENT00362)
    }
    
    func imgLogoTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        imgLogoTappedCounter += 1
        print(imgLogoTappedCounter)
        if imgLogoTappedCounter == DomainConst.MAXIMUM_TAPPED {
            imgLogoTappedCounter = 0
            BaseModel.shared.setTrainningMode(!BaseModel.shared.checkTrainningMode())
            showAlert(message: "Training mode is: " + (BaseModel.shared.checkTrainningMode() ? "ON" : "OFF"))
        }
    }
    
    // MARK: Utilities
    //++ BUG0157-SPJ (NguyenPT 20171004) Use facebook framework
    /**
     * Get data from facebook
     */
    internal func getDataFromFacebook() {
        //        if let token = AccessToken.current {
        //            let request = GraphRequest.init(
        //                graphPath: "me",
        //                parameters: ["fields": "id, name, first_name, email"],
        //                accessToken: token)
        //            request.start {
        //                (respond, result) -> Void in
        //                switch result {
        //                case .failed(let error):
        //                    self.showAlert(message: error.localizedDescription)
        //                    break
        //                case .success(response: _):
        ////                    if let data = resp.dictionaryValue {
        ////                        if let email = data["email"] {
        ////                            self.txtPhone.text = email as? String
        ////                        }
        ////                    }
        //                    self.inputPhone()
        //                    break
        //                }
        //            }
        //        }
    }
    
    /**
     * Handle input phone if can not get phone number from facebook
     */
    internal func inputPhone() {
        var tbxValue: UITextField?
        
        // Create alert
        let alert = UIAlertController(title: DomainConst.CONTENT00162,
                                      message: DomainConst.CONTENT00510,
                                      preferredStyle: .alert)
        // Add textfield
        alert.addTextField(configurationHandler: { textField -> Void in
            tbxValue = textField
            tbxValue?.placeholder       = DomainConst.CONTENT00054
            tbxValue?.clearButtonMode   = .whileEditing
            tbxValue?.returnKeyType     = .done
            tbxValue?.keyboardType      = .numberPad
            tbxValue?.textAlignment     = .center
            tbxValue?.text              = BaseModel.shared.getCurrentUsername()
        })
        
        // Add cancel action
        let cancel = UIAlertAction(title: DomainConst.CONTENT00202, style: .cancel, handler: nil)
        
        // Add ok action
        let ok = UIAlertAction(title: DomainConst.CONTENT00326, style: .default) { action -> Void in
            if let phone = tbxValue?.text {
                self.txtPhone.text = phone
                self.btnNextTapped(self)
            } else {
                self.showAlert(message: DomainConst.CONTENT00048, okTitle: DomainConst.CONTENT00251,
                               okHandler: {_ in
                                self.inputPhone()
                },
                               cancelHandler: {_ in
                                
                })
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    //-- BUG0157-SPJ (NguyenPT 20171004) Use facebook framework
    
    //    /**
    //     * Update view position
    //     * - parameter view: View need to update
    //     * - parameter x: X position
    //     * - parameter y: Y position
    //     * - parameter w: Width of view
    //     * - parameter h: Height of view
    //     */
    //    private func updateViewPos(view: UIView, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
    //        view.frame = CGRect(x: x, y: y, width: w, height: h)
    //    }
    
    // MARK - Logo image
    /**
     * Create logo image
     * - parameter yPos: Y position
     * - parameter w:    Width
     * - parameter h:    Height
     */
    private func createLogoImg(yPos: CGFloat, w: CGFloat, h: CGFloat) {
        imgLogo.image = ImageManager.getImage(named: DomainConst.LOGO_LOGIN_ICON_IMG_NAME)
        let tappedRecog = UITapGestureRecognizer(
            target: self,
            action: #selector(G00LoginExtVC.imgLogoTapped(_:)))
        imgLogo.isUserInteractionEnabled = true
        imgLogo.addGestureRecognizer(tappedRecog)
        imgLogo.contentMode = .scaleAspectFit
        
        //        createNextBtn()
        CommonProcess.updateViewPos(view: imgLogo,
                                    x: (UIScreen.main.bounds.width - w) / 2,
                                    y: yPos,
                                    w: w,
                                    h: h)
    }
    
    /**
     * Create logo image (in HD mode)
     */
    private func createLogoImgHD() {
        createLogoImg(yPos: LOGIN_LOGO_REAL_Y_POS_HD,
                      w: LOGIN_LOGO_REAL_WIDTH_HD,
                      h: LOGIN_LOGO_REAL_HEIGHT_HD)
    }
    
    /**
     * Create logo image (in Full HD mode)
     */
    private func createLogoImgFHD() {
        //        updateViewPos(view: imgLogo,
        //                      x: (UIScreen.main.bounds.width - LOGIN_LOGO_REAL_WIDTH_FHD) / 2,
        //                      y: LOGIN_LOGO_REAL_Y_POS_FHD,
        //                      w: LOGIN_LOGO_REAL_WIDTH_FHD,
        //                      h: LOGIN_LOGO_REAL_HEIGHT_FHD)
        createLogoImg(yPos: LOGIN_LOGO_REAL_Y_POS_FHD,
                      w: LOGIN_LOGO_REAL_WIDTH_FHD,
                      h: LOGIN_LOGO_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create logo image (in Full HD Landscape mode)
     */
    private func createLogoImgFHD_L() {
        //        updateViewPos(view: imgLogo,
        //                      x: (UIScreen.main.bounds.width  - LOGIN_LOGO_REAL_WIDTH_FHD_L) / 2,
        //                      y: LOGIN_LOGO_REAL_Y_POS_FHD_L,
        //                      w: LOGIN_LOGO_REAL_WIDTH_FHD_L,
        //                      h: LOGIN_LOGO_REAL_HEIGHT_FHD_L)
        createLogoImg(yPos: LOGIN_LOGO_REAL_Y_POS_FHD_L,
                      w: LOGIN_LOGO_REAL_WIDTH_FHD_L,
                      h: LOGIN_LOGO_REAL_HEIGHT_FHD_L)
    }
    
    /**
     * Update logo image in HD mode
     */
    private func updateLogoImgHD() {
        CommonProcess.updateViewPos(
            view: imgLogo,
            x: (UIScreen.main.bounds.width - LOGIN_LOGO_REAL_WIDTH_HD) / 2,
            y: LOGIN_LOGO_REAL_Y_POS_HD,
            w: LOGIN_LOGO_REAL_WIDTH_HD,
            h: LOGIN_LOGO_REAL_HEIGHT_HD)
    }
    
    /**
     * Update logo image in Full HD mode
     */
    private func updateLogoImgFHD() {
        CommonProcess.updateViewPos(
            view: imgLogo,
            x: (UIScreen.main.bounds.width - LOGIN_LOGO_REAL_WIDTH_FHD) / 2,
            y: LOGIN_LOGO_REAL_Y_POS_FHD,
            w: LOGIN_LOGO_REAL_WIDTH_FHD,
            h: LOGIN_LOGO_REAL_HEIGHT_FHD)
    }
    
    /**
     * Update logo image in Full HD Landscape mode
     */
    private func updateLogoImgFHD_L() {
        CommonProcess.updateViewPos(
            view: imgLogo,
            x: (UIScreen.main.bounds.width - LOGIN_LOGO_REAL_WIDTH_FHD_L) / 2,
            y: LOGIN_LOGO_REAL_Y_POS_FHD_L,
            w: LOGIN_LOGO_REAL_WIDTH_FHD_L,
            h: LOGIN_LOGO_REAL_HEIGHT_FHD_L)
    }
    
    /**
     * Create login label
     */
    private func createLoginLabel() {
        lblLogin.frame = CGRect(x: 0,
                                y: imgLogo.frame.maxY + GlobalConst.MARGIN,
                                width: UIScreen.main.bounds.width,
                                height: GlobalConst.LABEL_H)
        lblLogin.text           = DomainConst.CONTENT00051.uppercased()
        lblLogin.textColor      = UIColor.black
        lblLogin.font           = GlobalConst.BASE_FONT
        lblLogin.textAlignment  = .center
    }
    
    /**
     * Update login label
     */
    private func updateLoginLabel() {
        CommonProcess.updateViewPos(view: lblLogin,
                                    x: 0,
                                    y: imgLogo.frame.maxY + GlobalConst.MARGIN,
                                    w: UIScreen.main.bounds.width,
                                    h: GlobalConst.LABEL_H)
    }
    
    /**
     * Create phone text field (in HD mode)
     */
    private func createPhoneTextFieldHD() {
        self.createPhoneTextField(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_HD) / 2,
            y: lblLogin.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_HD,
            h: LOGIN_PHONE_REAL_HEIGHT_HD)
    }
    
    /**
     * Create phone text field (in Full HD mode)
     */
    private func createPhoneTextFieldFHD() {
        self.createPhoneTextField(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD) / 2,
            y: lblLogin.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create phone text field (in Full HD Landscape mode)
     */
    private func createPhoneTextFieldFHD_L() {
        self.createPhoneTextField(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD_L) / 2,
            y: lblLogin.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD_L,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD_L)
    }
    
    /**
     * Create phone text field
     * - parameter x: X position
     * - parameter y: Y position
     * - parameter w: Width of view
     * - parameter h: Height of view
     */
    private func createPhoneTextField(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        txtPhone.frame              = CGRect(x: x, y: y, width: w, height: h)
        txtPhone.placeholder        = DomainConst.CONTENT00049
        txtPhone.backgroundColor    = UIColor.white
        txtPhone.borderStyle        = .roundedRect
        txtPhone.textAlignment      = .center
        txtPhone.layer.cornerRadius = GlobalConst.BUTTON_CORNER_RADIUS_NEW
        txtPhone.returnKeyType      = .next
        txtPhone.adjustsFontSizeToFitWidth = true
    }
    
    /**
     * Update phone text field (in HD mode)
     */
    private func updatePhoneTextFieldHD() {
        CommonProcess.updateViewPos(view: txtPhone,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_HD) / 2,
                                    y: lblLogin.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_HD,
                                    h: LOGIN_PHONE_REAL_HEIGHT_HD)
    }
    
    /**
     * Update phone text field (in Full HD mode)
     */
    private func updatePhoneTextFieldFHD() {
        CommonProcess.updateViewPos(view: txtPhone,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD) / 2,
                                    y: lblLogin.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_FHD,
                                    h: LOGIN_PHONE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Update phone text field (in Full HD Landscape mode)
     */
    private func updatePhoneTextFieldFHD_L() {
        CommonProcess.updateViewPos(view: txtPhone,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD_L) / 2,
                                    y: lblLogin.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_FHD_L,
                                    h: LOGIN_PHONE_REAL_HEIGHT_FHD_L)
    }
    
    // MARK: Password textfield
    /**
     * Create password text field
     * - parameter x: X position
     * - parameter y: Y position
     * - parameter w: Width of view
     * - parameter h: Height of view
     */
    private func createPasswordTextField(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        txtPassword.frame              = CGRect(x: x, y: y, width: w, height: h)
        txtPassword.placeholder        = DomainConst.CONTENT00050
        txtPassword.backgroundColor    = UIColor.white
        txtPassword.textAlignment      = .center
        txtPassword.borderStyle        = .roundedRect
        txtPassword.layer.cornerRadius = GlobalConst.BUTTON_CORNER_RADIUS_NEW
        txtPassword.isSecureTextEntry = true
        txtPassword.returnKeyType      = .done
        txtPassword.adjustsFontSizeToFitWidth = true
    }
    
    /**
     * Create password text field (in HD mode)
     */
    private func createPasswordTextFieldHD() {
        self.createPasswordTextField(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_HD) / 2,
            y: txtPhone.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_HD,
            h: LOGIN_PHONE_REAL_HEIGHT_HD)
    }
    
    /**
     * Create password text field (in Full HD mode)
     */
    private func createPasswordTextFieldFHD() {
        self.createPasswordTextField(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD) / 2,
            y: txtPhone.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create password text field (in Full HD Landscape mode)
     */
    private func createPasswordTextFieldFHD_L() {
        self.createPasswordTextField(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD_L) / 2,
            y: txtPhone.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD_L,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD_L)
    }
    
    /**
     * Update password text field (in HD mode)
     */
    private func updatePasswordTextFieldHD() {
        CommonProcess.updateViewPos(view: txtPassword,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_HD) / 2,
                                    y: txtPhone.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_HD,
                                    h: LOGIN_PHONE_REAL_HEIGHT_HD)
    }
    
    /**
     * Update password text field (in Full HD mode)
     */
    private func updatePasswordTextFieldFHD() {
        CommonProcess.updateViewPos(view: txtPassword,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD) / 2,
                                    y: txtPhone.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_FHD,
                                    h: LOGIN_PHONE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Update password text field (in Full HD Landscape mode)
     */
    private func updatePasswordTextFieldFHD_L() {
        CommonProcess.updateViewPos(view: txtPassword,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD_L) / 2,
                                    y: txtPhone.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_FHD_L,
                                    h: LOGIN_PHONE_REAL_HEIGHT_FHD_L)
    }
    
    /**
     * Create next button
     */
    private func createNextBtn() {
        btnNext.setImage(ImageManager.getImage(named: DomainConst.NEXT_BUTTON_ICON_IMG_NAME),
                         for: .normal)
        btnNext.addTarget(self, action: #selector(btnNextTapped(_:)), for: .touchUpInside)
        txtPhone.rightView = btnNext
        txtPhone.rightViewMode = .always
    }
    
    /**
     * Create next button (in HD mode)
     */
    private func createNextBtnHD() {
        createNextBtn()
        CommonProcess.updateViewPos(view: btnNext,
                                    x: CGFloat(txtPhone.frame.width - LOGIN_NEXT_BUTTON_REAL_SIZE_HD * 2),
                                    y: (txtPhone.frame.height - LOGIN_NEXT_BUTTON_REAL_SIZE_HD ) / 2,
                                    w: LOGIN_NEXT_BUTTON_REAL_SIZE_HD,
                                    h: LOGIN_NEXT_BUTTON_REAL_SIZE_HD)
    }
    
    /**
     * Create next button (in Full HD mode)
     */
    private func createNextBtnFHD() {
        createNextBtn()
        CommonProcess.updateViewPos(view: btnNext,
                                    x: CGFloat(txtPhone.frame.width - LOGIN_NEXT_BUTTON_REAL_SIZE_FHD * 2),
                                    y: (txtPhone.frame.height - LOGIN_NEXT_BUTTON_REAL_SIZE_FHD ) / 2,
                                    w: LOGIN_NEXT_BUTTON_REAL_SIZE_FHD,
                                    h: LOGIN_NEXT_BUTTON_REAL_SIZE_FHD)
    }
    
    /**
     * Create next button (in Full HD Landscape mode)
     */
    private func createNextBtnFHD_L() {
        createNextBtn()
        CommonProcess.updateViewPos(view: btnNext,
                                    x: CGFloat(txtPhone.frame.width - LOGIN_NEXT_BUTTON_REAL_SIZE_FHD_L * 2),
                                    y: (txtPhone.frame.height - LOGIN_NEXT_BUTTON_REAL_SIZE_FHD_L ) / 2,
                                    w: LOGIN_NEXT_BUTTON_REAL_SIZE_FHD_L,
                                    h: LOGIN_NEXT_BUTTON_REAL_SIZE_FHD_L)
    }
    
    /**
     * Create login label
     */
    private func createORLabel() {
        lblOr.frame = CGRect(x: 0,
                             y: txtPassword.frame.maxY + GlobalConst.MARGIN,
                             width: UIScreen.main.bounds.width,
                             height: GlobalConst.LABEL_H)
        lblOr.text              = DomainConst.CONTENT00472
        lblOr.textColor      = UIColor.black
        lblOr.font           = GlobalConst.BASE_FONT
        lblOr.textAlignment  = .center
    }
    
    /**
     * Update login label
     */
    private func updateORLabel() {
        CommonProcess.updateViewPos(view: lblOr,
                                    x: 0,
                                    y: txtPassword.frame.maxY + GlobalConst.MARGIN,
                                    w: UIScreen.main.bounds.width,
                                    h: GlobalConst.LABEL_H)
    }
    
    /**
     * Create facebook button
     * - parameter x: X position
     * - parameter y: Y position
     * - parameter w: Width of view
     * - parameter h: Height of view
     */
    private func createFBBtn(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        btnFacebook.frame = CGRect(x: x, y: y, width: w, height: h)
        btnFacebook.setTitle(DomainConst.CONTENT00051, for: UIControlState())
        btnFacebook.setTitleColor(UIColor.white, for: UIControlState())
        //        btnFacebook.titleLabel?.font    = UIFont.systemFont(ofSize: GlobalConst.BUTTON_FONT_SIZE)
        btnFacebook.backgroundColor     = GlobalConst.MAIN_COLOR_GAS_24H
        btnFacebook.layer.cornerRadius  = GlobalConst.BUTTON_CORNER_RADIUS_NEW
        btnFacebook.addTarget(self, action: #selector(btnFacebookTapped(_:)), for: .touchUpInside)
        //        btnFacebook.leftImage(image: ImageManager.getImage(named: DomainConst.LOGO_FACEBOOK_ICON_IMG_NAME)!)
        //        btnFacebook.imageView?.contentMode = .scaleAspectFit
        //        btnFacebook.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    private func createCustomerButton(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        let btn = UIButton()
        btn.frame = CGRect(x: x, y: y, width: w, height: h)
        btn.setTitle("Dành cho bệnh nhân", for: UIControlState())
        btn.setTitleColor(GlobalConst.MAIN_COLOR_GAS_24H, for: UIControlState())
        btn.backgroundColor     = .white
        btn.layer.cornerRadius  = GlobalConst.BUTTON_CORNER_RADIUS_NEW
        btn.layer.borderWidth   = 0.5
        btn.layer.borderColor   = GlobalConst.MAIN_COLOR_GAS_24H.cgColor
        btn.addTarget(self, action: #selector(customerButtonAction), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    @objc func customerButtonAction() {
        let vc = G05F00S01VC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     * Create facebook button (in HD mode)
     */
    private func createFBBtnHD() {
        self.createFBBtn(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_HD) / 2,
            y: lblOr.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_HD,
            h: LOGIN_PHONE_REAL_HEIGHT_HD)
        self.createCustomerButton(x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_HD) / 2, y: btnFacebook.frame.maxY + GlobalConst.MARGIN*8, w: LOGIN_PHONE_REAL_WIDTH_HD, h: LOGIN_PHONE_REAL_HEIGHT_HD)
    }
    
    /**
     * Create facebook button (in Full HD mode)
     */
    private func createFBBtnFHD() {
        self.createFBBtn(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD) / 2,
            y: lblOr.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create facebook button (in Full HD Landscape mode)
     */
    private func createFBBtnFHD_L() {
        self.createFBBtn(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD_L) / 2,
            y: lblOr.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD_L,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD_L)
    }
    
    /**
     * Update facebook button (in HD mode)
     */
    private func updateFBBtnHD() {
        CommonProcess.updateViewPos(view: btnFacebook,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_HD) / 2,
                                    y: lblOr.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_HD,
                                    h: LOGIN_PHONE_REAL_HEIGHT_HD)
    }
    
    /**
     * Update facebook button (in Full HD mode)
     */
    private func updateFBBtnFHD() {
        CommonProcess.updateViewPos(view: btnFacebook,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD) / 2,
                                    y: lblOr.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_FHD,
                                    h: LOGIN_PHONE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Update facebook button (in Full HD Landscape mode)
     */
    private func updateFBBtnFHD_L() {
        CommonProcess.updateViewPos(view: btnFacebook,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD_L) / 2,
                                    y: lblOr.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_FHD_L,
                                    h: LOGIN_PHONE_REAL_HEIGHT_FHD_L)
    }
    
    /**
     * Create zalo button
     * - parameter x: X position
     * - parameter y: Y position
     * - parameter w: Width of view
     * - parameter h: Height of view
     */
    private func createZLBtn(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        btnZalo.frame = CGRect(x: x, y: y, width: w, height: h)
        btnZalo.setTitle(DomainConst.CONTENT00474, for: UIControlState())
        btnZalo.setTitleColor(UIColor.white, for: UIControlState())
        btnZalo.titleLabel?.font = UIFont.systemFont(ofSize: GlobalConst.BUTTON_FONT_SIZE)
        btnZalo.backgroundColor = GlobalConst.ZALO_BKG_COLOR
        btnZalo.layer.cornerRadius = GlobalConst.BUTTON_CORNER_RADIUS_NEW
        btnZalo.addTarget(self, action: #selector(btnZaloTapped(_:)), for: .touchUpInside)
        btnZalo.leftImage(image: ImageManager.getImage(named: DomainConst.LOGO_ZALO_ICON_IMG_NAME)!)
        btnZalo.imageView?.contentMode = .scaleAspectFit
        btnZalo.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    /**
     * Create zalo button (in HD mode)
     */
    private func createZLBtnHD() {
        self.createZLBtn(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_HD) / 2,
            y: btnFacebook.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_HD,
            h: LOGIN_PHONE_REAL_HEIGHT_HD)
    }
    
    /**
     * Create zalo button (in Full HD mode)
     */
    private func createZLBtnFHD() {
        self.createZLBtn(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD) / 2,
            y: btnFacebook.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create zalo button (in Full HD Landscape mode)
     */
    private func createZLBtnFHD_L() {
        self.createZLBtn(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD_L) / 2,
            y: btnFacebook.frame.maxY + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD_L,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD_L)
    }
    
    /**
     * Update zalo button (in HD mode)
     */
    private func updateZLBtnHD() {
        CommonProcess.updateViewPos(view: btnZalo,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_HD) / 2,
                                    y: btnFacebook.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_HD,
                                    h: LOGIN_PHONE_REAL_HEIGHT_HD)
    }
    
    /**
     * Update zalo button (in Full HD mode)
     */
    private func updateZLBtnFHD() {
        CommonProcess.updateViewPos(view: btnZalo,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD) / 2,
                                    y: btnFacebook.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_FHD,
                                    h: LOGIN_PHONE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Update zalo button (in Full HD Landscape mode)
     */
    private func updateZLBtnFHD_L() {
        CommonProcess.updateViewPos(view: btnZalo,
                                    x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD_L) / 2,
                                    y: btnFacebook.frame.maxY + GlobalConst.MARGIN,
                                    w: LOGIN_PHONE_REAL_WIDTH_FHD_L,
                                    h: LOGIN_PHONE_REAL_HEIGHT_FHD_L)
    }
    
    //++ BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
    // MARK: Support label
    /**
     * Create support label
     */
    private func createSupportLabel() {
        lblSupport.frame = CGRect(x: 0,
                                  y: lblHotline.frame.minY - GlobalConst.LABEL_H,
                                  width: UIScreen.main.bounds.width,
                                  height: GlobalConst.LABEL_H)
        lblSupport.text           = DomainConst.CONTENT00539
        lblSupport.textColor      = UIColor.black
        lblSupport.font           = GlobalConst.BASE_FONT
        lblSupport.textAlignment  = .center
    }
    
    private func updateSupportLabel() {
        CommonProcess.updateViewPos(
            view: lblSupport,
            x: 0, y: lblHotline.frame.minY - GlobalConst.LABEL_H,
            w: UIScreen.main.bounds.width,
            h: GlobalConst.LABEL_H)
    }
    
    // MARK: Hotline label
    /**
     * Create hotline label
     * - parameter bottomY: Y position bottom
     */
    private func createHotlineLabel(bottomY: CGFloat) {
        let height = GlobalConst.LABEL_H * 2
        lblHotline.frame = CGRect(x: 0,
                                  y: UIScreen.main.bounds.height - height * bottomY,
                                  width: UIScreen.main.bounds.width,
                                  height: height)
        lblHotline.text           = DomainConst.HOTLINE
        lblHotline.textColor      = GlobalConst.MAIN_COLOR_GAS_24H
        lblHotline.font           = UIFont.boldSystemFont(ofSize: GlobalConst.NOTIFY_FONT_SIZE)
        lblHotline.textAlignment  = .center
    }
    
    /**
     * Create hotline label (HD mode)
     */
    private func createHotlineLabelHD() {
        createHotlineLabel(bottomY: 2.5)
    }
    
    /**
     * Create hotline label (Full HD mode)
     */
    private func createHotlineLabelFHD() {
        createHotlineLabel(bottomY: 5)
    }
    
    /**
     * Create hotline label (Full HD Landscape mode)
     */
    private func createHotlineLabelFHD_L() {
        createHotlineLabel(bottomY: 3)
    }
    
    /**
     * Update hotline label
     */
    private func updateHotlineLabel(bottomY: CGFloat) {
        let height = GlobalConst.LABEL_H * 2
        CommonProcess.updateViewPos(view: lblHotline,
                                    x: 0,
                                    y: UIScreen.main.bounds.height - height * bottomY,
                                    w: UIScreen.main.bounds.width,
                                    h: height)
    }
    
    private func updateHotlineLabelHD() {
        updateHotlineLabel(bottomY: 2.5)
    }
    
    private func updateHotlineLabelFHD() {
        updateHotlineLabel(bottomY: 5)
    }
    
    private func updateHotlineLabelFHD_L() {
        updateHotlineLabel(bottomY: 3)
    }
    //-- BUG0177-SPJ (NguyenPT 20171207) Add hotline in Login and Confirm code screen
    
    private func setLocalData() {
        self.txtPhone.text = BaseModel.shared.getCurrentUsername()
    }
}
