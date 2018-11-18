//
//  G00HomeVC.swift
//  dental
//
//  Created by SPJ on 1/9/18.
//  Copyright © 2018 SPJ. All rights reserved.
//
//  P0031_GetStatistic_API

import UIKit
import harpyframework

enum RoleEnum: String {
    case customer = "3"
    case employee = "4"
    case director = "5"
    case doctor = "6"
    case receptionist = "8"
    case saler = "9"
}

class G00HomeVC: BaseParentViewController {
    // MARK: Properties
    /** Logo */
    var imgLogo:        UIImageView = UIImageView()
    /** Statistic Detail View*/
    var qrCodeView: QRCodeMainView!
    var statisticDetailView: StatisticsDetailView!
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
    
    var statisticParam: GetStatisticsRequest!
    var receiptParam: GetListReceiptRequest!

    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createNavigationBar(title: DomainConst.CONTENT00571)
        startLogic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    /**
     *  Get domain
     */
    func getDomain() {
        let param = GetDomainRequest()
        if let bundleId = Bundle.main.bundleIdentifier {
            if BaseModel.shared.checkTrainningMode() {
                param.bundle_id = bundleId + ".training"
            } else {
                param.bundle_id = bundleId
            }
        }
        serviceInstance.getDomain(param: param, success: { (domain) in
            BaseModel.shared.setServerUrl(url: domain)
            /** Start normal logic*/
            self.startNormalLogic()
            
        }) { (error) in
            BaseModel.shared.setDefaultServerUrl()
            self.showAlert(message: error.message)
        }
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
    }
    
    /**
     * Create children views
     */
    override func createChildrenViews() {
        super.createChildrenViews()
        // Get current device type
//        switch UIDevice.current.userInterfaceIdiom {
//        case .phone:        // iPhone
//            self.createLogoImgHD()
//            break
//        case .pad:          // iPad
//            switch UIApplication.shared.statusBarOrientation {
//            case .portrait, .portraitUpsideDown:        // Portrait
//                self.createLogoImgFHD()
//            case .landscapeLeft, .landscapeRight:       // Landscape
//                self.createLogoImgFHD_L()
//            default:
//                break
//            }
//
//            break
//        default:
//            break
//        }
//
//        self.view.addSubview(imgLogo)
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
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                self.createLogoImgFHD()
            case .landscapeLeft, .landscapeRight:       // Landscape
                self.createLogoImgFHD_L()
            default:
                break
            }
            
            break
        default:
            break
        }
    }
    
    // MARK - Logo image
    /**
     * Create logo image
     * - parameter yPos: Y position
     * - parameter w:    Width
     * - parameter h:    Height
     */
    private func createLogoImg(yPos: CGFloat, w: CGFloat, h: CGFloat) {
        imgLogo.image = ImageManager.getImage(named: DomainConst.LOGO_LOGIN_ICON_IMG_NAME)
        imgLogo.contentMode = .scaleAspectFit
        
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
        createLogoImg(yPos: LOGIN_LOGO_REAL_Y_POS_FHD,
                      w: LOGIN_LOGO_REAL_WIDTH_FHD,
                      h: LOGIN_LOGO_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create logo image (in Full HD Landscape mode)
     */
    private func createLogoImgFHD_L() {
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
    
    // MARK: Event handler
    internal func finishUpdateConfigRequest(_ notification: Notification) {
        let data = notification.object as! String
        let model = LoginRespBean(jsonString: data)
        if model.isSuccess() {
            LoginRespBean.saveConfigData(data: model)
            if model.data.role_id == RoleEnum.receptionist.rawValue {
                self.loadQRCodeContent()
            } else {
                self.loadStatisticContent()
            }
        }
    }
    
    /**
     * Finish request
     */
    override func finishRequest(_ model: Any?) {
        let data = model as! String
        let model = DomainNameRespBean(jsonString: data)
        if model.isSuccess() && !model.data.isEmpty {
            BaseModel.shared.setServerUrl(url: model.data)
        } else {
            BaseModel.shared.setDefaultServerUrl()
        }
        startNormalLogic()
    }
    
    // MARK: Logic
    /**
     * Handle get domain name
     */
    private func startGetDomainName() {
        // Get bundle id value
        if let bundleId = Bundle.main.bundleIdentifier {
            // If in training mode
            if BaseModel.shared.checkTrainningMode() {
                DomainNameRequest.request(view: self,
                                          bundleId: bundleId + ".training",
                                          completionHandler: finishRequest)
            } else {
                // Running mode
                DomainNameRequest.request(view: self,
                                          bundleId: bundleId,
                                          completionHandler: finishRequest)
            }
        } else {    // Get bundle id failed
            BaseModel.shared.setDefaultServerUrl()
        }
    }
    
    /**
     * Start normal logic
     */
    private func startNormalLogic() {
        if BaseModel.shared.checkIsLogin() {
            requestUpdateConfig()
        } else {
            openLogin()
        }
    }
    
    /**
     * Start logic
     */
    private func startLogic() {
        if BaseModel.shared.getServerURL().isEmpty {
//            startGetDomainName()
            getDomain()
        } else {
            startNormalLogic()
        }
    }
    
    /**
     * Request update config
     */
    private func requestUpdateConfig() {
        UpdateConfigurationRequest.requestUpdateConfiguration(
            action: #selector(finishUpdateConfigRequest(_:)),
            view: self)
    }

    /** BUG0089 ++ */
    func loadStatisticContent() {
        statisticDetailView = StatisticsDetailView()
        statisticDetailView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(statisticDetailView)
        self.view.bringSubview(toFront: statisticDetailView)
        statisticDetailView.delegate = self
        self.statisticParam = statisticDetailView.getParamToday()
        statisticDetailView.param = self.statisticParam
        self.getStatistics(param: self.statisticParam)
    }
    /* API Get today statistic detail of user */
    func getStatistics(param: GetStatisticsRequest) {
        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        serviceInstance.getStatistics(req: param, success: { (resp) in
            self.statisticDetailView.alpha = 1
            self.statisticDetailView.loadUI(statistic: resp)
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.view.bringSubview(toFront: self.statisticDetailView)
        }) { (error) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.statisticDetailView.alpha = 0
            self.showAlert(message: error.message)
        }
    }
    /** BUG0089 -- */
    /** BUG0099 ++ */
    func loadQRCodeContent() {
        qrCodeView = QRCodeMainView()
        qrCodeView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(qrCodeView)
        qrCodeView.delegate = self
        self.view.bringSubview(toFront: qrCodeView)
//        getUserByQRCode("5C170E86CA3B7")
    }
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
    /** BUG0099 -- */
}
//MARK: - QRCodeMainViewDelegate
extension G00HomeVC: QRCodeMainViewDelegate {
    func qRCodeMainViewDidSelectScan() {
        let vc = G04F01S01VC()
        vc.didGetCode { (code) in
            self.qrCodeView.setCode(code)
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
//MARK: - StatisticDetailViewDelegate
extension G00HomeVC: StatisticsDetailViewDelegate {
    func statisticsDetailViewDidSelectCollected() {
        self.receiptParam = GetListReceiptRequest()
        receiptParam.date_from = statisticParam.date_from
        receiptParam.date_to = statisticParam.date_to
        receiptParam.agent_id = statisticParam.agent_id
        receiptParam.status = LoginBean.shared.getReceiptStatusCollected().id
        let vc = StatisticsListViewController(withParam: receiptParam)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func statisticsDetailViewDidSelectNotCollected() {
        self.receiptParam = GetListReceiptRequest()
        receiptParam.date_from = statisticParam.date_from
        receiptParam.date_to = statisticParam.date_to
        receiptParam.agent_id = statisticParam.agent_id
        receiptParam.status = LoginBean.shared.getReceiptStatusNotCollected().id
        let vc = StatisticsListViewController(withParam: receiptParam)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}




