//
//  G00AccountExtVC.swift
//  project
//
//  Created by SPJ on 10/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G00AccountExtVC: BaseParentViewController {
    // MARK: Properties
    /** Data */
    var _data:          [ConfigurationModel] = [ConfigurationModel]()
    /** Information table view */
    var _tblInfo:            UITableView             = UITableView()
    
    // MARK: Static values
    // MARK: Constant
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Navigation
        self.createNavigationBar(title: DomainConst.CONTENT00528)
        requestData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestData(isShowLoading: false)
    }
    
    /**
     * Handle update constants
     */
    override func updateConst() {
        super.updateConst()
    }
    
    /**
     * Create children views
     */
    override func createChildrenViews() {
        super.createChildrenViews()
        createInfoTableView()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        self.view.addSubview(_tblInfo)
    }
    
    /**
     * Update children views
     */
    override func updateChildrenViews() {
        super.updateChildrenViews()
        updateInfoTableView()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                break
            default:
                break
            }
            
            break
        default:
            break
        }
    }
    
    /**
     * Set data
     */
    override func setData(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = UserProfileRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.setUserInfo(userInfo: model.data)
            _data.removeAll()
            _data.append(ConfigurationModel(
                id: DomainConst.NUMBER_ZERO_VALUE,
                name: DomainConst.CONTENT00542,
                iconPath: DomainConst.NAME_ICON_IMG_NAME,
                value: BaseModel.shared.getUserInfo().getName()))
            _data.append(ConfigurationModel(
                id: DomainConst.NUMBER_ONE_VALUE,
                name: DomainConst.CONTENT00152,
                iconPath: DomainConst.PHONE_ICON_NEW_IMG_NAME,
                value: BaseModel.shared.getUserInfo().getPhone()))
            _data.append(ConfigurationModel(
                id: DomainConst.NUMBER_TWO_VALUE,
                name: DomainConst.CONTENT00088,
                iconPath: DomainConst.ADDRESS_ICON_NEW_IMG_NAME,
                value: BaseModel.shared.getUserInfo().getAddress()))
            _tblInfo.reloadData()
        } else {
            showAlert(message: model.message)
        }
    }
    
    // MARK: Event handler
    
    // MARK: Logic
    /**
     * Request data
     */
    internal func requestData(isShowLoading: Bool = true) {
        UserProfileRequest.requestUserProfile(
            action: #selector(setData(_:)), view: self,
            isShowLoading: isShowLoading)
    }
    
    // MARK: Layout
    // MARK: Information table view
    private func createInfoTableView() {
        _tblInfo.frame = CGRect(x: 0, y: 0,
                               width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
        _tblInfo.dataSource = self
        _tblInfo.delegate = self
        _tblInfo.separatorStyle = .none
    }
    
    private func updateInfoTableView() {
        CommonProcess.updateViewPos(
            view: _tblInfo,
            x: 0, y: 0,
            w: UIScreen.main.bounds.width,
            h: UIScreen.main.bounds.height)
    }
    
}

// MARK: Protocol - UITableViewDataSource
extension G00AccountExtVC: UITableViewDataSource {
    /**
     * Asks the data source to return the number of sections in the table view.
     * - returns: 1 section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /**
     * Tells the data source to return the number of rows in a given section of a table view.
     * - returns: List information count
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return _data.count
        } else {
            return 2
        }
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            if indexPath.row < self._data.count {
                let data = self._data[indexPath.row]
                cell.imageView?.image = ImageManager.getImage(
                    named: data.getIconPath(), margin: GlobalConst.MARGIN)
                cell.imageView?.contentMode = .scaleAspectFit
                cell.textLabel?.text = data.name
                cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
                cell.detailTextLabel?.text = data.getValue()
                cell.detailTextLabel?.font = GlobalConst.BASE_BOLD_FONT
                cell.detailTextLabel?.lineBreakMode = .byWordWrapping
                cell.detailTextLabel?.numberOfLines = 0
            }
            
            return cell
        case 1:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = DomainConst.CONTENT00442
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = UIColor.white
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.contentView.backgroundColor = GlobalConst.MAIN_COLOR_GAS_24H
            case 1:
                cell.textLabel?.text = DomainConst.CONTENT00089
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = UIColor.white
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.contentView.backgroundColor = GlobalConst.TEXT_COLOR_GRAY
//            case 2:
//                cell.textLabel?.text = DomainConst.VERSION_CODE_WITH_NAME
//                cell.textLabel?.textAlignment = .center
//                break
//            case 3:
//                cell.textLabel?.text = DomainConst.CONTENT00090
//                cell.textLabel?.textAlignment = .center
//                cell.textLabel?.textColor = UIColor.white
//                cell.contentView.backgroundColor = GlobalConst.BUTTON_COLOR_YELLOW_NEW
//                break
            default:
                break
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalConst.LABEL_H * 3
    }
}

// MARK: Protocol - UITableViewDelegate
extension G00AccountExtVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let view = G00AccountEditVC(
                    nibName: G00AccountEditVC.theClassName,
                    bundle: nil)
                if let controller = BaseViewController.getCurrentViewController() {
                    controller.navigationController?.pushViewController(view, animated: true)
                }
                break
            case 1:
//                self.updateVersionAppStore()
                break
//            case 3:
//                LogoutRequest.requestLogout(action: #selector(self.finishRequestLogout), view: self)
//                break
            default:
                break
            }
        }
    }
}
