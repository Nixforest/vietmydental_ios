//
//  G01F03S01VC.swift
//  dental
//
//  Created by SPJ on 2/19/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F03S01VC: ChildExtViewController {
    // MARK: Properties
    /** Treatment id */
    var _treatmentId:       String                  = DomainConst.BLANK
    /** Data */
    var _data:              ListConfigBean          = ListConfigBean()
    /** Create process flag */
    var _flagCreate:        Bool                    = false
    /** Open Receipt flag */
    var _flagOpenReceipt:   Bool                    = false
    /** Need open receipt flag */
    var _flagNeedOpenReceipt: Bool                  = false
    /** constrain height footer view */
    @IBOutlet weak var heightFooter: NSLayoutConstraint!
    /** Information table view */
    @IBOutlet weak var _tblInfo: UITableView!
    // MARK: Static values
    // MARK: Constant
    let FOOTER_HEIGHT:      CGFloat                 = 40.0
    var HEADER_HEIGHT:      CGFloat = GlobalConst.LABEL_H * 2
    
    var footer: UIView!
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.createNavigationBar(title: DomainConst.CONTENT00554)
        _tblInfo.dataSource = self
        _tblInfo.delegate = self
//        showFooter(isShow: !canUpdate())
        showFooter(isShow: isCompleted())
    }
    
    /**
     * Notifies the view controller that its view was added to a view hierarchy.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //check show button finish
        if canShowBtnFinish() {
            showBtnFinish()
        }
        
        // Check if table view has selected item
        if let selectedIndex = _tblInfo.indexPathForSelectedRow, selectedIndex.section == 0 {
            // Get selected model
            let data = self._data.getData()[selectedIndex.row]
            switch data.id {
            case DomainConst.ITEM_DIAGNOSIS:
                // Check temp value is not empty
                if !BaseModel.shared.sharedString.isEmpty {
                    self._data.setData(id: DomainConst.ITEM_DIAGNOSIS_ID, value: BaseModel.shared.sharedString)
                    requestUpdate(isShowLoading: false)
                }
//            case DomainConst.ITEM_TEETH:
//                if !BaseModel.shared.sharedString.isEmpty {
//                    self._data.setData(id: DomainConst.ITEM_TEETH_ID, value: BaseModel.shared.sharedString)
//                    requestUpdate(isShowLoading: false)
//                }
            case DomainConst.ITEM_TEETH_INFO:
//                if !BaseModel.shared.sharedArrayConfig.isEmpty {
                    self._data.setArrayData(id: DomainConst.ITEM_TEETH_INFO, value: BaseModel.shared.sharedArrayConfig)
                    BaseModel.shared.sharedArrayConfig.removeAll()
                    requestUpdate(isShowLoading: false)
//                }
            case DomainConst.ITEM_TREATMENT:
                if !BaseModel.shared.sharedString.isEmpty {
                    self._data.setData(id: DomainConst.ITEM_TREATMENT_TYPE_ID, value: BaseModel.shared.sharedString)
                    requestUpdate(isShowLoading: false)
                }
            default:
                break
            }
        }
        if _flagCreate {
            let data = BaseModel.shared.sharedString
            if !data.isEmpty {
                let model = TreatmentScheduleProcessCreateRespBean(jsonString: data)
                if model.isSuccess() {
                    self._data.getData(id: DomainConst.ITEM_DETAILS)._dataExt.append(model.data)
                    self._tblInfo.reloadData()
                }
            }
            
            _flagCreate = false
        }
        
        if _flagOpenReceipt {
            let data = BaseModel.shared.sharedString
            if !data.isEmpty {
                if let dict = CommonProcess.getDictionary(fromString: data) {
                    let beanReceipt = ConfigExtBean(jsonData: dict as! [String : AnyObject])
                    if isHaveReceipt() {
                        self._data.getData(id: DomainConst.ITEM_RECEIPT)._dataExt = beanReceipt._dataExt
                    } else {
                        self._data._data.append(beanReceipt)
                    }
                }
            }
            
            _flagOpenReceipt = false
        }
        BaseModel.shared.sharedString = DomainConst.BLANK
    }
    
    func isHaveReceipt() -> Bool {
        for item in _data._data {
            if item.id == DomainConst.ITEM_RECEIPT {
                return true
            }
        }
        return false
    }
    
    /**
     * Set data
     * - parameter bean: Data to set
     * - parameter treatmentId: Treatment id
     */
    public func setData(bean: [ConfigExtBean], treatmentId: String) {
        self._data.setData(data: bean)
        self._treatmentId = treatmentId
        // Status is not complete
        if !isCompleted() {
            _flagNeedOpenReceipt = true
        }
//        showFooter(isShow: !self.canUpdate())
    }
    
    
    /**
     * Handle select diagnosis
     * - parameter title: Title of screen
     */
    public func createSelectScreenDiagnosis(title: String) {
        let view = G01F02S03VC(nibName: G01F02S03VC.theClassName, bundle: nil)
        view.createNavigationBar(title: title)
        view.setData(data: LoginBean.shared.getDiagnosisConfigs(),
                     selectedValue: self._data.getData(
                        id: DomainConst.ITEM_DIAGNOSIS_ID)._dataStr)
        self.push(view, animated: true)
    }
    
    /**
     * Handle select teeth
     * - parameter title: Title of screen
     */
    public func createSelectScreenTeeth(title: String) {
//        let view = SelectionVC(nibName: SelectionVC.theClassName, bundle: nil)
        let view = G01F03S05VC(nibName: G01F03S05VC.theClassName, bundle: nil)
        view.createNavigationBar(title: title)
        view.setData(data: LoginBean.shared.teeth,
                     selectedValue: "")
        view.setSelectedArray(value: self._data.getData(
            id: DomainConst.ITEM_TEETH_INFO).data)
        BaseModel.shared.sharedArrayConfig = self._data.getData(
            id: DomainConst.ITEM_TEETH_INFO).data
        self.push(view, animated: true)
    }
    
    /**
     * Handle select treatment type
     * - parameter title: Title of screen
     */
    public func createSelectScreenTreatment(title: String) {
        let view = G01F03S02VC(nibName: G01F03S02VC.theClassName, bundle: nil)
        view.createNavigationBar(title: title)
        view.setDataExt(data: LoginBean.shared.treatment,
                        selectedValue: self._data.getData(id: DomainConst.ITEM_TREATMENT_TYPE_ID)._dataStr)
        self.push(view, animated: true)
    }
    
    public func openImageXRayInfoScreen() {
//        let view = G01F03S06VC(nibName: G01F03S06VC.theClassName, bundle: nil)
//        view.createNavigationBar(title: self._data.getData(id: DomainConst.ITEM_IMAGE).name)
//        let listConfig = ListConfigBean()
//        listConfig.setData(data: self._data.getData(id: DomainConst.ITEM_IMAGE)._dataExt)
//        view.setDataExt(data: listConfig, selectedValue: "")
//        self.push(view, animated: true)
        showAlert(message: DomainConst.CONTENT00362)
    }
    
    internal func requestUpdate(isShowLoading: Bool = true) {
        var arrData = [String]()
        for item in self._data.getData(id: DomainConst.ITEM_TEETH_INFO).data {
            arrData.append(item.id)         
        }
        let teethInfo = String.init(format: "%@%@%@", "[", arrData.joined(separator: ","), "]")
        TreatmentScheduleDetailUpdateRequest.request(
            action: #selector(finishUpdate(_:)),
            view: self,
            id: self._data.getData(id: DomainConst.ITEM_ID)._dataStr,
            teeth_id: self._data.getData(id: DomainConst.ITEM_TEETH_ID)._dataStr,
            teeth_info: teethInfo,
            diagnosis: self._data.getData(id: DomainConst.ITEM_DIAGNOSIS_ID)._dataStr,
            treatment: self._data.getData(id: DomainConst.ITEM_TREATMENT_TYPE_ID)._dataStr,
            status: self._data.getData(id: DomainConst.ITEM_STATUS)._dataStr,
            isShowLoading: isShowLoading)
    }
    
    internal func finishUpdate(_ notification: Notification) {
        let data = notification.object as! String
        let model = TreatmentInfoRespBean(jsonString: data)
        if model.isSuccess() {
            self.setData(bean: model.data.getData(), treatmentId: self._treatmentId)
            _tblInfo.reloadData()
//            self.showFooter(isShow: !self.canUpdate())
            self.showFooter(isShow: isCompleted())
            if self.isCompleted() && _flagNeedOpenReceipt {
                self.openReceipt()
                _flagNeedOpenReceipt = false
            }
            //check show button finish
            if canShowBtnFinish() {
                showBtnFinish()
            }
        }
    }
    
    
    
    /**
     * Handle show treatment schedule process
     * - parameter bean: Process data
     */
    public func openTreatmentScheduleProcess(bean: ConfigExtBean) {
        let view = G01F04S01VC(nibName: G01F04S01VC.theClassName,
                               bundle: nil)
        view.createNavigationBar(title: bean.name)
        view.setData(bean: bean._dataExt)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(
                view, animated: true)
        }
    }
    
    internal func addNew(_ sender: AnyObject) {
        self._flagCreate = true
        openCreateTreatmentScheduleProcess()
    }
    
    /**
     * Open create treatment schedule detail screen
     */
    func openCreateTreatmentScheduleProcess() -> Void {
        let view = G01F04S02VC(nibName: G01F04S02VC.theClassName,
                               bundle: nil)
        let data = self._data.getData(id: DomainConst.ITEM_DETAILS)._dataExt
        if !data.isEmpty {
            var copyArr = [ConfigExtBean]()
            for item in data[0]._dataExt {
                let copyData = ConfigExtBean(copy: item)
                if copyData.id == DomainConst.ITEM_TEETH_ID {
                    copyData._dataStr = self._data.getData(id: DomainConst.ITEM_TEETH_ID)._dataStr
                } else if copyData.id == DomainConst.ITEM_TEETH {
                    copyData._dataStr = self._data.getData(id: DomainConst.ITEM_TEETH)._dataStr
                }
                copyArr.append(copyData)
            }
            
            view.setData(bean: copyArr,
                         detailId: self._data.getData(id: DomainConst.ITEM_ID)._dataStr)
            view.resetData()
        }
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(
                view, animated: true)
        }
    }
    
    // MARK: Logic
    /**
     * Check if data is full fill
     * - returns: True if all field (id, diagnosis, treatment type) have updated all,
     *              False otherwise
     */
    private func isDataFullFill() -> Bool {
        for item in self._data._data {
            switch item.id {
            case DomainConst.ITEM_DIAGNOSIS_ID,
                 DomainConst.ITEM_TREATMENT_TYPE_ID:
                if item._dataStr.isBlank {
                    return false
                }
            default:
                break
            }
        }
        return true
    }
    func canShowBtnFinish() -> Bool {
//        for item in self._data._data {
//            switch item.id {
////            case DomainConst.ITEM_TEETH_ID,
//            case DomainConst.ITEM_DIAGNOSIS_ID,
//                 DomainConst.ITEM_TREATMENT_TYPE_ID:
//                if item._dataStr.isBlank {
//                    return false
//                }
//            default:
//                break
//            }
//        }
        if !canUpdate() {
            return false
        }
        return true
    }
    func showBtnFinish() {
        createRightNavigationItem(title: DomainConst.CONTENT00558,
                                  action: #selector(confirmToFinish(_:)),
                                  target: self)
    }
    /**
     * Check if current treatment schedule is in completed status
     * - returns: True if value of status item is Completed, False otherwise
     */
    internal func isCompleted() -> Bool {
        return (self._data.getData(id: DomainConst.ITEM_STATUS)._dataStr
            == DomainConst.TREATMENT_SCHEDULE_DETAIL_COMPLETED)
    }
    
    /**
     * Check if current treatment schedule is in schedule status
     * - returns: True if value of status item is Schedule, False otherwise
     */
    internal func isSchedule() -> Bool {
        return (self._data.getData(id: DomainConst.ITEM_STATUS)._dataStr
            == DomainConst.TREATMENT_SCHEDULE_DETAIL_SCHEDULE)
    }
    
    /**
     * Check if current treatment schedule can update data
     * - returns: True if value of can_update item is 1, False otherwise
     */
    internal func canUpdate() -> Bool {
        return self._data.getData(id: DomainConst.ITEM_CAN_UPDATE)._dataStr.isON()
    }
    /**
     * Handle finish treatment schedule detail
     */
    internal func handleFinish() {
        showAlert(message: DomainConst.CONTENT00561,
                  okHandler: {
                    alert in
                    // Request finish treatment schedule detail
                    self.finishTreatmentScheduleDetail()
        },
                  cancelHandler: {
                    alert in
                    // Do nothing
        })
    }
    
    internal func confirmToFinish(_ sender: AnyObject) {
        if !isDataFullFill() {
            showAlert(message: DomainConst.CONTENT00576,
                      okHandler: { alert in
                        self.handleFinish()
            },
                      cancelHandler: { alert in
                        // Do nothing
            })
        } else {
            handleFinish()
        }
    }
    
    /**
     * Request server finish treatment schedule detail
     */
    internal func finishTreatmentScheduleDetail() {
        var arrData = [String]()
        for item in self._data.getData(id: DomainConst.ITEM_TEETH_INFO).data {
            arrData.append(item.id)         
        }
        let teethInfo = String.init(format: "%@%@%@", "[", arrData.joined(separator: ","), "]")
        TreatmentScheduleDetailUpdateRequest.request(
            action: #selector(finishUpdate(_:)),
            view: self,
            id: self._data.getData(id: DomainConst.ITEM_ID)._dataStr,
            teeth_id: self._data.getData(id: DomainConst.ITEM_TEETH_ID)._dataStr,
            teeth_info: teethInfo,
            diagnosis: self._data.getData(id: DomainConst.ITEM_DIAGNOSIS_ID)._dataStr,
            treatment: self._data.getData(id: DomainConst.ITEM_TREATMENT_TYPE_ID)._dataStr,
            status: DomainConst.TREATMENT_SCHEDULE_DETAIL_COMPLETED,
            isShowLoading: false)
    }
    
    // MARK: Layout
    
    
    /**
     * Show/hide footer view base on flag
     * - parameter isShow: Flag show/hide footer view
     */
    private func showFooter(isShow: Bool) {
        if isShow {
            heightFooter.constant = FOOTER_HEIGHT
            self.view.layoutIfNeeded()
        } else {
            heightFooter.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    /**
     *  Open G01F03S04VC - Detail treatment process controller
     *  turn on _flagOpenReceipt
     */
    private func openReceipt() {
        _flagOpenReceipt = true
        let vc = G01F03S04ViewController()
        vc.amount = LoginBean.shared.getTreatmentConfig(id: self._data.getData(id: DomainConst.ITEM_TREATMENT_TYPE_ID)._dataStr)._dataStr
        vc.debt = self._data.getData(id: DomainConst.ITEM_CUSTOMER_DEBT)._dataStr
        
        
        for bean in _data._data {
            if bean.id == DomainConst.ITEM_RECEIPT {
                vc.receiptBean = bean
                var obj = ConfigExtBean()
                
                obj.id = DomainConst.ITEM_ID
                obj.name = DomainConst.CONTENT00570
                obj._dataStr = vc.amount
                vc.receiptBean._dataExt.append(obj)
                
                obj = ConfigExtBean()
                obj.id = DomainConst.ITEM_CUSTOMER_DEBT
                obj.name = DomainConst.CONTENT00577
                obj._dataStr = vc.debt
                vc.receiptBean._dataExt.append(obj)
//                for child in bean.getListData() {
//                    vc.receiptBean._dataExt.append(child)
//                }
            }
        }
        vc.detailID = self._data.getData(id: DomainConst.ITEM_ID)._dataStr
        vc.createNavigationBar(title: DomainConst.CONTENT00574)
        self.push(vc, animated: true)
    }
    @IBAction func btnPayAction(_ sender: Any) {
        openReceipt()
    }
}

// MARK: Protocol - UITableViewDataSource
extension G01F03S01VC: UITableViewDataSource {
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
            let data = self._data.getData(id: DomainConst.ITEM_DETAILS)._dataExt
            if data.count > 1 {
                return data.count
            } else if data.count == 1 {
                if data[0].id.isEmpty {
                    return 0
                } else {
                    return 1
                }
            }
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
            case DomainConst.ITEM_CAN_UPDATE,
                 DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_DIAGNOSIS_ID,
                 DomainConst.ITEM_TEETH_ID,
                 DomainConst.ITEM_ID,
                 DomainConst.ITEM_START_DATE,
                 DomainConst.ITEM_TREATMENT_TYPE_ID,
                 DomainConst.ITEM_TIME_ID,
                 DomainConst.ITEM_DETAILS,
                 DomainConst.ITEM_TYPE,
                 DomainConst.ITEM_RECEIPT,
                 DomainConst.ITEM_TEETH:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.contentView.isHidden = true
                return cell
            case DomainConst.ITEM_NOTE:
//                 DomainConst.ITEM_TYPE:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                if !self.isSchedule() {
                    cell.contentView.isHidden = true
                } else {
                    cell.textLabel?.text = data.name
                    cell.textLabel?.font = GlobalConst.BASE_FONT
                    cell.detailTextLabel?.text = data._dataStr
                    cell.detailTextLabel?.font = GlobalConst.BASE_FONT
                    cell.imageView?.image = image
                    cell.imageView?.contentMode = .scaleAspectFit
                }
                return cell
            case DomainConst.ITEM_END_DATE:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                if !self.isCompleted() {
                    cell.contentView.isHidden = true
                } else {
                    cell.textLabel?.text = data.name
                    cell.textLabel?.font = GlobalConst.BASE_FONT
                    cell.detailTextLabel?.text = data._dataStr
                    cell.detailTextLabel?.font = GlobalConst.BASE_FONT
                    cell.imageView?.image = image
                    cell.imageView?.contentMode = .scaleAspectFit
                }
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
            case DomainConst.ITEM_IMAGE:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.text = DomainConst.BLANK
                cell.detailTextLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.lineBreakMode = .byWordWrapping
                cell.accessoryType = .detailDisclosureButton
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
                if data._dataStr.isEmpty && self.canUpdate() {
                    cell.detailTextLabel?.text = LoginBean.shared.getUpdateText()
                    cell.detailTextLabel?.textColor = UIColor.red
                }
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            }
        case 1:     // Section Treatment schedule process
            let data = self._data.getData(id: DomainConst.ITEM_DETAILS)._dataExt[indexPath.row]
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.textLabel?.text = "- " + data.name
            cell.textLabel?.font = GlobalConst.BASE_FONT
//            cell.detailTextLabel?.text = data.name
//            cell.detailTextLabel?.font = GlobalConst.BASE_FONT
//            if data.name.isEmpty && self.canUpdate() {
//                cell.detailTextLabel?.text = LoginBean.shared.getUpdateText()
//                cell.detailTextLabel?.textColor = UIColor.red
//            }
            cell.accessoryType = .disclosureIndicator
            if data.id.isEmpty {
                cell.isHidden = true
            }
            return cell
        default:
            break
        }
        
        return UITableViewCell()        
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F03S01VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row > self._data.count() {
                return
            }
            let data = self._data.getData()[indexPath.row]
            switch data.id {
            case DomainConst.ITEM_DIAGNOSIS:
                if self.canUpdate() {
                    self.createSelectScreenDiagnosis(title: data.name)
                }
//            case DomainConst.ITEM_TEETH:
//                if self.canUpdate() {
//                    self.createSelectScreenTeeth(title: data.name)
//                }
            case DomainConst.ITEM_TEETH_INFO:
                self.createSelectScreenTeeth(title: data.name)
            case DomainConst.ITEM_TREATMENT:
                if self.canUpdate() {
                    self.createSelectScreenTreatment(title: data.name)
                }
            case DomainConst.ITEM_IMAGE:
                self.openImageXRayInfoScreen()
            default:
                break
            }
            break
        case 1:
            let data = self._data.getData(id: DomainConst.ITEM_DETAILS)._dataExt[indexPath.row]
            self.openTreatmentScheduleProcess(bean: data)
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
            let data = self._data.getData()[indexPath.row]
            switch data.id {
            case DomainConst.ITEM_CAN_UPDATE,
                 DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_DIAGNOSIS_ID,
                 DomainConst.ITEM_TEETH_ID,
                 DomainConst.ITEM_TEETH,
                 DomainConst.ITEM_ID,
                 DomainConst.ITEM_START_DATE,
                 DomainConst.ITEM_TREATMENT_TYPE_ID,
                 DomainConst.ITEM_TIME_ID,
                 DomainConst.ITEM_DETAILS,
                 DomainConst.ITEM_TYPE,
                 DomainConst.ITEM_RECEIPT:
                return 0
            case DomainConst.ITEM_END_DATE:
                if self.isCompleted() {
                    return UITableViewAutomaticDimension
                } else {
                    return 0
                }
            case DomainConst.ITEM_NOTE,
                 DomainConst.ITEM_TYPE:if self.isSchedule() {
                    return UITableViewAutomaticDimension
                } else {
                    return 0
                }
            default:
                return UITableViewAutomaticDimension
            }
        case 1:
            let data = self._data.getData(id: DomainConst.ITEM_DETAILS)._dataExt[indexPath.row]
            if data.id.isEmpty {
                return 0
            } else {
                return UITableViewAutomaticDimension
            }
        default:
            return UITableViewAutomaticDimension
        }        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            return nil
//        }
//        let header = CustomerInfoHeaderView.init(
//            frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: HEADER_HEIGHT))
//        header.setHeader(bean: self._data.getData(id: DomainConst.ITEM_DETAILS),
//                         actionText: DomainConst.CONTENT00065)
//        header.delegate = self
//        return header
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return HEADER_HEIGHT
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F03S01VC: CustomerInfoHeaderViewDelegate {    
    func customerInfoHeaderViewDidSelect(object: ConfigExtBean) {
        switch object.id {
        case DomainConst.ITEM_DETAILS:
            self.addNew(self)
        default:
            break
        }
    }
}
