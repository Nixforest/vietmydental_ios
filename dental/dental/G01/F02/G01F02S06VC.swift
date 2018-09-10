//
//  G01F02S06VC.swift
//  dental
//
//  Created by SPJ on 2/19/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F02S06VC: ChildExtViewController {
    // MARK: Properties
    /** Data */
    var _data:              ListConfigBean          = ListConfigBean()
    /** Customer id */
    var _customerId:        String                  = DomainConst.BLANK
    /** Information table view */
    var _tblInfo:           UITableView             = UITableView()
    /** Date */
    var _date:              Date                    = Date()
    /** Time */
    var _time:              String                  = DomainConst.BLANK
    
    // MARK: Static values
    // MARK: Constant    
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createNavigationBar(title: DomainConst.CONTENT00553)
        createRightNavigationItem(title: DomainConst.CONTENT00558,
                                  action: #selector(addNew(_:)),
                                  target: self)
        createInfoTableView()
        self.view.addSubview(_tblInfo)
        autoInput(rowIdx: 0)
    }
    
    /**
     * Notifies the view controller that its view was added to a view hierarchy.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check if table view has selected item
        if let selectedIndex = _tblInfo.indexPathForSelectedRow, selectedIndex.section == 0 {
            // Get selected model
            let data = self._data.getData()[selectedIndex.row]
            switch data.id {
            case DomainConst.ITEM_TIME_ID:
                // Check temp value is not empty
                if !BaseModel.shared.sharedString.isEmpty {
                    self._time = BaseModel.shared.sharedString
                    self._data.setData(id: data.id, value: LoginBean.shared.getTimerConfig(id: self._time))
                    _tblInfo.reloadData()
                    autoInput(rowIdx: 1)
                }
            default:
                break
            }
        }
        
        BaseModel.shared.sharedString = DomainConst.BLANK
    }
    
    /**
     * Set data
     */
    override func setData(_ notification: Notification) {
        let data = notification.object as! String
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            self.backButtonTapped(self)
        } else {
            showAlert(message: model.message)
        }
    }
    
    /**
     * Set data
     * - parameter customerId: Customer id
     */
    public func setData(customerId: String) {
        self._data.setData(id: DomainConst.ITEM_TIME_ID,
                           value: "",
                           name: DomainConst.CONTENT00562)
        self._data.setData(id: DomainConst.ITEM_START_DATE,
                           value: "",
                           name: DomainConst.CONTENT00563)
        self._data.setData(id: DomainConst.ITEM_NOTE,
                           value: "",
                           name: DomainConst.CONTENT00565)
//        self._data.setData(id: DomainConst.ITEM_TYPE,
//                           value: "",
//                           name: DomainConst.CONTENT00565)
        self._customerId = customerId
    }
    
    public func resetData() {
        self._data.resetStrData()
    }
    
    internal func addNew(_ sender: AnyObject) {
        requestCreate()
    }
    
    internal func requestCreate(isShowLoading: Bool = true) {
        TreatmentCreateRequest.request(
            action: #selector(setData(_:)),
            view: self,
            customer_id: self._customerId,
            time: self._time,
            date: CommonProcess.getDateString(date: self._date, format: DomainConst.DATE_TIME_FORMAT_2),
            doctor_id: LoginBean.shared.getUserId(),
            type: self._data.getData(id: DomainConst.ITEM_TYPE)._dataStr,
            note: self._data.getData(id: DomainConst.ITEM_NOTE)._dataStr)
    }
    
    // MARK: Logic
    private func autoInput(rowIdx: Int) {
        let index = IndexPath(item: rowIdx, section: 0)
        self._tblInfo.selectRow(at: index, animated: true, scrollPosition: .middle)
        switch rowIdx {
        case 0:
            let bean = self._data.getData(id: DomainConst.ITEM_TIME_ID)
            createSelectScreenTimer(title: bean.name)
            break
        case 1:
            let bean = self._data.getData(id: DomainConst.ITEM_START_DATE)
            inputDate(id: bean.id)
            break
        case 2:
            let bean = self._data.getData(id: DomainConst.ITEM_NOTE)
            inputText(bean: bean)
            break
        default:
            break
        }
    }
    /**
     * Handle input date
     * - parameter id: Id of item
     */
    internal func inputDate(id: String) {
        var date = Date()
        // If date value is not empty
        if !self._data.getData(id: DomainConst.ITEM_START_DATE)._dataStr.isEmpty {
            date = self._date
        }
        self._date = date
        self._data.setData(id: DomainConst.ITEM_START_DATE,
                           value: date.dateString())
        self._tblInfo.reloadData()
        let alert = UIAlertController(style: .actionSheet,
                                      title: DomainConst.CONTENT00559)
        alert.addDatePicker(mode: .date, date: date,
                            minimumDate: nil, maximumDate: nil,
                            action: {date in
                                self._date = date
                                self._data.setData(
                                    id: DomainConst.ITEM_START_DATE,
//                                  value: date.dateTimeString())
                                    value: CommonProcess.getDateString(date: date, format: DomainConst.DATE_TIME_FORMAT_1))
                                self._tblInfo.reloadData()
                                self.autoInput(rowIdx: 2)
        })
        let ok = UIAlertAction(title: DomainConst.CONTENT00008, style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     * Handle input text
     * - parameter bean: Data of item
     */
    internal func inputText(bean: ConfigExtBean) {
        var title           = DomainConst.BLANK
        var message         = DomainConst.BLANK
        var placeHolder     = DomainConst.BLANK
        var keyboardType    = UIKeyboardType.default
        var value           = DomainConst.BLANK
        switch bean.id {
        case DomainConst.ITEM_NAME:
            title           = bean.name
            value           = bean._dataStr
            break
        default:
            title           = bean.name
            value           = bean._dataStr
            message         = DomainConst.BLANK
            placeHolder     = DomainConst.BLANK
            keyboardType    = UIKeyboardType.default
            break
        }
        var tbxValue: UITextField?
        
        // Create alert
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        // Add textfield
        alert.addTextField(configurationHandler: { textField -> Void in
            tbxValue = textField
            tbxValue?.placeholder       = placeHolder
            tbxValue?.clearButtonMode   = .whileEditing
            tbxValue?.returnKeyType     = .done
            tbxValue?.keyboardType      = keyboardType
            tbxValue?.text              = value
            tbxValue?.textAlignment     = .center
        })
        
        // Add cancel action
        let cancel = UIAlertAction(title: DomainConst.CONTENT00202, style: .cancel, handler: nil)
        
        // Add ok action
        let ok = UIAlertAction(title: DomainConst.CONTENT00008, style: .default) {
            action -> Void in
            if let newValue = tbxValue?.text, !newValue.isEmpty {
                self._data.setData(id: bean.id, value: newValue)
                self._tblInfo.reloadData()
            } else {
                self.showAlert(message: DomainConst.CONTENT00551,
                               okHandler: {
                                alert in
                                self.inputText(bean: bean)
                })
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        if let popVC = alert.popoverPresentationController {
            popVC.sourceView = self.view
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     * Handle create select time screen
     * - parameter title: Title of screen
     */
    internal func createSelectScreenTimer(title: String) {
        let view = G01F02S04VC(nibName: G01F02S04VC.theClassName, bundle: nil)
        view.createNavigationBar(title: title)
        view.setData(data: LoginBean.shared.timer,
                     selectedValue: self._time)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
    }
    
    // MARK: Layout
    
    // MARK: Information table view
    private func createInfoTableView() {
        _tblInfo.frame = CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height)
        _tblInfo.dataSource = self
        _tblInfo.delegate = self
    }
}

// MARK: Protocol - UITableViewDataSource
extension G01F02S06VC: UITableViewDataSource {
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
            return self._data.count()
        } else {
            // For future
            return 0
        }
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row > self._data.count() {
                return UITableViewCell()
            }
            let data = self._data.getData()[indexPath.row]
            var imagePath = DomainConst.INFORMATION_IMG_NAME
            if let img = DomainConst.VMD_IMG_LIST[data.id] {
                imagePath = img
            }
            let image = ImageManager.getImage(named: imagePath,
                                              margin: GlobalConst.MARGIN * 2)
            switch data.id {
            case DomainConst.ITEM_ID,
                 DomainConst.ITEM_END_DATE,
                 DomainConst.ITEM_DIAGNOSIS_ID, 
                 DomainConst.ITEM_PATHOLOGICAL_ID,
                 DomainConst.ITEM_HEALTHY,
                 DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_CAN_UPDATE,
                 DomainConst.ITEM_TYPE,
                 DomainConst.ITEM_DETAILS:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.contentView.isHidden = true
                return cell
            default:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.text = data._dataStr
                cell.detailTextLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.lineBreakMode = .byWordWrapping
                cell.detailTextLabel?.numberOfLines = 0
                if data._dataStr.isEmpty {
                    cell.detailTextLabel?.text = LoginBean.shared.getUpdateText()
                    cell.detailTextLabel?.textColor = UIColor.red
                }
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            }
        case 1:     // For future
            break
        default:
            break
        }
        
        return UITableViewCell()        
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F02S06VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row > self._data.count() {
                return
            }
            let data = self._data.getData()[indexPath.row]
            switch data.id {
            case DomainConst.ITEM_START_DATE:
                self.inputDate(id: data.id)
//            case DomainConst.ITEM_TYPE,
            case DomainConst.ITEM_NOTE:
                inputText(bean: data)
            case DomainConst.ITEM_CAN_UPDATE, DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_TEETH_ID,
                 DomainConst.ITEM_TYPE,
                 DomainConst.ITEM_ID, DomainConst.ITEM_DOCTOR:
                return
            case DomainConst.ITEM_TIME_ID:
                createSelectScreenTimer(title: data.name)
            default:
                break
            }
            break
        default:
            break
        }
        
    }
    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch self._data.getData()[indexPath.row].id {
            case DomainConst.ITEM_ID,
                 DomainConst.ITEM_END_DATE,
                 DomainConst.ITEM_DIAGNOSIS_ID, 
                 DomainConst.ITEM_PATHOLOGICAL_ID,
                 DomainConst.ITEM_HEALTHY,
                 DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_CAN_UPDATE,
                 DomainConst.ITEM_TYPE,
                 DomainConst.ITEM_DETAILS:
                return 0
            default:
                return UITableViewAutomaticDimension
            }
        default:
            return UITableViewAutomaticDimension
        }
        
    }
}
