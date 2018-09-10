//
//  G01F03S03VC.swift
//  dental
//
//  Created by SPJ on 2/20/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F03S03VC: ChildExtViewController {
    // MARK: Properties
    /** Data */
    var _data:              ListConfigBean          = ListConfigBean()
    /** Treatment schedule id */
    var _scheduleId:         String                  = DomainConst.BLANK
    /** Information table view */
    var _tblInfo:           UITableView             = UITableView()
    /** Date */
    var _date:              Date                    = Date()
    /** Flag run first time */
    var _isFirstTime:       Bool                    = false
    
    // MARK: Static values
    // MARK: Constant
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createNavigationBar(title: DomainConst.CONTENT00557)
        createRightNavigationItem(title: DomainConst.CONTENT00558,
                                  action: #selector(addNew(_:)),
                                  target: self)
        createInfoTableView()
        self.view.addSubview(_tblInfo)
//        if _isFirstTime {
//            autoInput(rowIdx: 0)
//        }
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
            let id = BaseModel.shared.sharedString
            switch data.id {
            case DomainConst.ITEM_DIAGNOSIS:
                if !id.isEmpty {
                    self._data.setData(id: DomainConst.ITEM_DIAGNOSIS_ID, value: id)
                    self._data.setData(id: DomainConst.ITEM_DIAGNOSIS,
                                       value: LoginBean.shared.getDiagnosisConfig(id: id))
                    _tblInfo.reloadData()
                    if _isFirstTime {
                        autoInput(rowIdx: 3)
                        _isFirstTime = false
                    }
                }
            case DomainConst.ITEM_TEETH:
                if !id.isEmpty {
                    self._data.setData(id: DomainConst.ITEM_TEETH_ID, value: id)
                    self._data.setData(id: DomainConst.ITEM_TEETH,
                                       value: LoginBean.shared.getTeethConfig(id: id))
                    _tblInfo.reloadData()
                }
            case DomainConst.ITEM_TEETH_INFO:
//                if !BaseModel.shared.sharedArrayConfig.isEmpty {
                    self._data.setArrayData(id: DomainConst.ITEM_TEETH_INFO, value: BaseModel.shared.sharedArrayConfig)
                    BaseModel.shared.sharedArrayConfig.removeAll()
                    _tblInfo.reloadData()
                    if _isFirstTime {
                        autoInput(rowIdx: 2)
                }
//                }
            case DomainConst.ITEM_TREATMENT:
                if !id.isEmpty {
                    self._data.setData(id: DomainConst.ITEM_TREATMENT_TYPE_ID, value: id)
                    self._data.setData(id: DomainConst.ITEM_TREATMENT,
                                       value: LoginBean.shared.getTreatmentConfig(id: id).name)
                    _tblInfo.reloadData()
                }
            case DomainConst.ITEM_TIME:
                // Check temp value is not empty
                if !id.isEmpty {
                    self._data.setData(id: DomainConst.ITEM_TIME_ID, value: id)
                    self._data.setData(id: data.id, value: LoginBean.shared.getTimerConfig(id: id))
                    _tblInfo.reloadData()
                    if _isFirstTime {
                        autoInput(rowIdx: 1)
                    }
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
     * - parameter scheduleId: Treatment schedule id
     */
    public func setData(bean: [ConfigExtBean], scheduleId: String) {
//    public func setData(scheduleId: String) {
        self._data.setData(data: bean)
        self._scheduleId = scheduleId
//        self._data.setData(id: DomainConst.ITEM_TIME_ID,
//                           value: "",
//                           name: DomainConst.CONTENT00562)
//        self._data.setData(id: DomainConst.ITEM_START_DATE,
//                           value: "",
//                           name: DomainConst.CONTENT00563)
//        self._data.setData(id: DomainConst.ITEM_TEETH_ID,
//                           value: "",
//                           name: DomainConst.CONTENT00566)
//        self._data.setData(id: DomainConst.ITEM_DIAGNOSIS_ID,
//                           value: "",
//                           name: DomainConst.CONTENT00567)
//        self._data.setData(id: DomainConst.ITEM_TREATMENT_TYPE_ID,
//                           value: "",
//                           name: DomainConst.CONTENT00568)
    }
    
    public func resetData() {
        self._data.resetStrData()
    }
    
    internal func addNew(_ sender: AnyObject) {
        requestCreate()
    }
    
    internal func requestCreate(isShowLoading: Bool = true) {
        var arrData = [String]()
        for item in self._data.getData(id: DomainConst.ITEM_TEETH_INFO).data {
            arrData.append(item.id)         
        }
        let teethInfo = String.init(format: "%@%@%@", "[", arrData.joined(separator: ","), "]")
        TreatmentScheduleDetailCreateRequest.request(
            action: #selector(setData(_:)),
            view: self,
            id: self._scheduleId,
            time: self._data.getData(id: DomainConst.ITEM_TIME_ID)._dataStr,
            date: CommonProcess.getDateString(date: self._date, format: "yyyy/MM/dd"),
            teeth_id: self._data.getData(id: DomainConst.ITEM_TEETH_ID)._dataStr,
            teeth_info: teethInfo,
            diagnosis: self._data.getData(id: DomainConst.ITEM_DIAGNOSIS_ID)._dataStr,
            treatment: self._data.getData(id: DomainConst.ITEM_TREATMENT_TYPE_ID)._dataStr,
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
                                self._data.setData(
                                    id: DomainConst.ITEM_START_DATE,
//                                    value: date.dateTimeString())
                                    value: CommonProcess.getDateString(date: date, format: DomainConst.DATE_TIME_FORMAT_1))
                                self._tblInfo.reloadData()
        })
        let ok = UIAlertAction(title: DomainConst.CONTENT00008, style: .cancel, handler: {
            alert in
            if self._isFirstTime {
                self.inputTeeth(id: DomainConst.ITEM_TEETH_INFO)
            }
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     * Handle select teeth
     * - parameter id: id of item
     */
    public func inputTeeth(id: String) {
//        let view = SelectionVC(nibName: SelectionVC.theClassName, bundle: nil)
        let view = G01F03S05VC(nibName: G01F03S05VC.theClassName, bundle: nil)
        view.createNavigationBar(title: self._data.getData(id: DomainConst.ITEM_TEETH_INFO).name)
        view.setData(data: LoginBean.shared.teeth,
                     selectedValue: "")
        view.setSelectedArray(value: self._data.getData(
            id: DomainConst.ITEM_TEETH_INFO).data)
        BaseModel.shared.sharedArrayConfig = self._data.getData(
            id: DomainConst.ITEM_TEETH_INFO).data
        self.push(view, animated: true)
    }
    
    /**
     * Handle select diagnosis
     */
    public func inputDiagnosis() {
        let view = G01F02S03VC(nibName: G01F02S03VC.theClassName, bundle: nil)
        view.createNavigationBar(title: self._data.getData(id: DomainConst.ITEM_DIAGNOSIS).name)
        view.setData(data: LoginBean.shared.getDiagnosisConfigs(),
                     selectedValue: self._data.getData(
                        id: DomainConst.ITEM_DIAGNOSIS_ID)._dataStr)
        self.push(view, animated: true)
    }
    
    /**
     * Handle select treatment type
     */
    public func inputTreatment() {
        let view = G01F03S02VC(nibName: G01F03S02VC.theClassName, bundle: nil)
        view.createNavigationBar(title: self._data.getData(id: DomainConst.ITEM_TREATMENT).name)
        view.setDataExt(data: LoginBean.shared.treatment,
                        selectedValue: self._data.getData(id: DomainConst.ITEM_TREATMENT_TYPE_ID)._dataStr)
        self.push(view, animated: true)
    }
    
    /**
     * Handle create select time screen
     * - parameter title: Title of screen
     */
    internal func createSelectScreenTimer(title: String) {
        let view = G01F02S04VC(nibName: G01F02S04VC.theClassName, bundle: nil)
        view.createNavigationBar(title: title)
        view.setData(data: LoginBean.shared.timer,
                     selectedValue: self._data.getData(id: DomainConst.ITEM_TIME_ID)._dataStr)
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
    
    // MARK: Logic
    private func autoInput(rowIdx: Int) {
        let index = IndexPath(item: rowIdx, section: 0)
        self._tblInfo.selectRow(at: index, animated: true, scrollPosition: .middle)
        switch rowIdx {
        case 0:
            let bean = self._data.getData(id: DomainConst.ITEM_TIME)
            createSelectScreenTimer(title: bean.name)
            break
        case 1:
            let bean = self._data.getData(id: DomainConst.ITEM_START_DATE)
            inputDate(id: bean.id)
            break
        case 2:
            let bean = self._data.getData(id: DomainConst.ITEM_TEETH_INFO)
            inputTeeth(id: bean.id)
            break
        case 3:
            inputDiagnosis()
            break
        case 4:
            inputTreatment()
            break
        default:
            break
        }
    }
}

// MARK: Protocol - UITableViewDataSource
extension G01F03S03VC: UITableViewDataSource {
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
                 DomainConst.ITEM_TEETH_ID,
                 DomainConst.ITEM_TEETH,
                 DomainConst.ITEM_TREATMENT_TYPE_ID, 
                 DomainConst.ITEM_NOTE,
                 DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_TYPE,
                 DomainConst.ITEM_CAN_UPDATE,
                 DomainConst.ITEM_TIME_ID,
                 DomainConst.ITEM_RECEIPT,
                 DomainConst.ITEM_CUSTOMER_DEBT,
                 DomainConst.ITEM_IMAGE,
                 DomainConst.ITEM_DETAILS:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.contentView.isHidden = true
                return cell
            case DomainConst.ITEM_TEETH_INFO:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                var name = data.name
                var value = LoginBean.shared.getUpdateText()
                let listInfo = data.data
                let count = listInfo.count
                if count == 1 {
                    value = listInfo[0].name
                } else if (count > 1) {
                    name = DomainConst.CONTENT00575
                    value = DomainConst.BLANK
                    cell.accessoryType = .detailDisclosureButton
                } else {
                    cell.detailTextLabel?.textColor = UIColor.red
                }
                cell.textLabel?.text = name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.text = value
                cell.detailTextLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.lineBreakMode = .byWordWrapping
                cell.imageView?.image = image
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
extension G01F03S03VC: UITableViewDelegate {
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
//            case DomainConst.ITEM_TEETH:
//                inputTeeth(id: data.id)
            case DomainConst.ITEM_TEETH_INFO:
                inputTeeth(id: data.id)
            case DomainConst.ITEM_DIAGNOSIS:
                inputDiagnosis()
            case DomainConst.ITEM_TREATMENT:
                inputTreatment()
            case DomainConst.ITEM_CAN_UPDATE, DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_TEETH_ID,
                 DomainConst.ITEM_ID, DomainConst.ITEM_DOCTOR:
                return
            case DomainConst.ITEM_TIME:
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
                 DomainConst.ITEM_TEETH_ID,
                 DomainConst.ITEM_TEETH,
                 DomainConst.ITEM_TREATMENT_TYPE_ID, 
                 DomainConst.ITEM_NOTE,
                 DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_TYPE,
                 DomainConst.ITEM_CAN_UPDATE,
                 DomainConst.ITEM_TIME_ID,
                 DomainConst.ITEM_RECEIPT,
                 DomainConst.ITEM_CUSTOMER_DEBT,
                 DomainConst.ITEM_IMAGE,
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
