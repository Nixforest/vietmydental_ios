//
//  G01F04S02VC.swift
//  dental
//
//  Created by SPJ on 2/21/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F04S02VC: ChildExtViewController {
    // MARK: Properties
    /** Data */
    var _data:              ListConfigBean          = ListConfigBean()
    /** Treatment schedule detail id */
    var _detailId:          String                  = DomainConst.BLANK
    /** Information table view */
    var _tblInfo:           UITableView             = UITableView()
    /** Date */
    var _date:              Date                    = Date()
    
    // MARK: Static values
    // MARK: Constant
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createNavigationBar(title: DomainConst.CONTENT00556)
        createRightNavigationItem(title: DomainConst.CONTENT00558,
                                  action: #selector(addNew(_:)),
                                  target: self)
        createInfoTableView()
        self.view.addSubview(_tblInfo)
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
            case DomainConst.ITEM_TEETH:
                let id = BaseModel.shared.sharedString
                if !id.isEmpty {
                    self._data.setData(id: DomainConst.ITEM_TEETH_ID, value: id)
                    self._data.setData(id: DomainConst.ITEM_TEETH,
                                       value: LoginBean.shared.getTeethConfig(id: id))
                    _tblInfo.reloadData()
                }
            default:
                break
            }
            BaseModel.shared.sharedString = DomainConst.BLANK
        }
    }
    
    /**
     * Set data
     */
    override func setData(_ notification: Notification) {
        let data = notification.object as! String
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.sharedString = data
            self.backButtonTapped(self)
        } else {
            showAlert(message: model.message)
        }
    }
    
    /**
     * Set data
     * - parameter bean: Data to set
     * - parameter detailId: Detail id
     */
    public func setData(bean: [ConfigExtBean], detailId: String) {
        self._data.setData(data: bean)
        self._detailId = detailId
    }
    
    public func resetData() {
        let teeth = self._data.getData(id: DomainConst.ITEM_TEETH)._dataStr
        let teethId = self._data.getData(id: DomainConst.ITEM_TEETH_ID)._dataStr 
        self._data.resetStrData()
        self._data.setData(id: DomainConst.ITEM_TEETH, value: teeth)
        self._data.setData(id: DomainConst.ITEM_TEETH_ID, value: teethId)
    }
    
    internal func addNew(_ sender: AnyObject) {
        requestCreate()
    }
    
    internal func requestCreate(isShowLoading: Bool = true) {
        TreatmentScheduleProcessCreateRequest.request(
            action: #selector(setData(_:)),
            view: self,
            id: self._detailId,
            date: CommonProcess.getDateString(date: self._date, format: "yyyy/MM/dd"),
            teeth_id: self._data.getData(id: DomainConst.ITEM_TEETH_ID)._dataStr,
            name: self._data.getData(id: DomainConst.ITEM_NAME)._dataStr,
            content: self._data.getData(id: DomainConst.ITEM_DESCRIPTION)._dataStr,
            note: self._data.getData(id: DomainConst.ITEM_NOTE)._dataStr,
            isShowLoading: isShowLoading)
    }
    
    // MARK: Logic
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
                                self._data.setData(id: DomainConst.ITEM_START_DATE,
                                                   value: date.dateString())
                                self._tblInfo.reloadData()
        })
        let ok = UIAlertAction(title: DomainConst.CONTENT00008, style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     * Handle input text
     * - parameter id: Id of item
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
     * Handle select teeth
     * - parameter id: id of item
     */
    public func inputTeeth(id: String) {
        let view = SelectionVC(nibName: SelectionVC.theClassName, bundle: nil)
        view.createNavigationBar(title: self._data.getData(id: DomainConst.ITEM_TEETH).name)
        view.setData(data: LoginBean.shared.teeth,
                     selectedValue: self._data.getData(
                        id: DomainConst.ITEM_TEETH_ID)._dataStr)
        self.push(view, animated: true)
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
extension G01F04S02VC: UITableViewDataSource {
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
            case DomainConst.ITEM_DETAILS:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_BOLD_FONT
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            case DomainConst.ITEM_CAN_UPDATE, DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_TEETH_ID,
                 DomainConst.ITEM_ID, DomainConst.ITEM_DOCTOR:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.contentView.isHidden = true
                return cell
            case DomainConst.ITEM_NAME:
                let imageObj = ImageManager.getImage(named: DomainConst.VMD_WORK_ICON_IMG_NAME,
                                                  margin: GlobalConst.MARGIN * 2)
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
                cell.imageView?.image = imageObj
                cell.imageView?.contentMode = .scaleAspectFit
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
extension G01F04S02VC: UITableViewDelegate {
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
            case DomainConst.ITEM_TEETH:
                inputTeeth(id: data.id)
            case DomainConst.ITEM_CAN_UPDATE, DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_TEETH_ID,
                 DomainConst.ITEM_ID, DomainConst.ITEM_DOCTOR:
                return
            default:
                inputText(bean: data)
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
            case DomainConst.ITEM_CAN_UPDATE, DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_TEETH_ID,
                 DomainConst.ITEM_ID, DomainConst.ITEM_DOCTOR:
                return 0
            default:
                return UITableViewAutomaticDimension
            }
        default:
            return UITableViewAutomaticDimension
        }
        
    }
}
