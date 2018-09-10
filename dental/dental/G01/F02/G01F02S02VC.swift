//
//  G01F02S02VC.swift
//  dental
//
//  Created by SPJ on 2/17/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F02S02VC: ChildExtViewController {
    // MARK: Properties
    /** Data */
    var _data:              TreatmentInfoRespBean   = TreatmentInfoRespBean()
    /** Treatment id */
    var _id:                String                  = DomainConst.BLANK
    /** Information table view */
    var _tblInfo:           UITableView             = UITableView()
    /** Refrest control */
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Static values
    // MARK: Constant
    var HEADER_HEIGHT:      CGFloat = GlobalConst.LABEL_H * 2
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createNavigationBar(title: DomainConst.CONTENT00552)
//        createRightNavigationItem(title: "+", action: #selector(addNew(_:)),
//                                  target: self)
        createInfoTableView()
        self.view.addSubview(_tblInfo)
        requestData()
    }
    
    /**
     * Notifies the view controller that its view was added to a view hierarchy.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var needRequestData = true
        // Check if table view has selected item
        if let selectedIndex = _tblInfo.indexPathForSelectedRow, selectedIndex.section == 0 {
            // Get selected model
            let data = self._data.data.getData()[selectedIndex.row]
            switch data.id {
            case DomainConst.ITEM_DIAGNOSIS:
                // Check temp value is not empty
                if !BaseModel.shared.sharedString.isEmpty {
                    self._data.data.setData(id: DomainConst.ITEM_DIAGNOSIS_ID, value: BaseModel.shared.sharedString)
                    requestUpdate()
                    needRequestData = false
                }
            case DomainConst.ITEM_PATHOLOGICAL:
                // Check temp value is not empty
                if !BaseModel.shared.sharedString.isEmpty {
                    self._data.data.setData(id: DomainConst.ITEM_PATHOLOGICAL_ID,
                                            value: BaseModel.shared.sharedString)
                    requestUpdate()
                    needRequestData = false
                }
            default:
                break
            }
        }
        
        BaseModel.shared.sharedString = DomainConst.BLANK
        if needRequestData {
            requestData(action: #selector(setData(_:)),
                        isShowLoading: false)
        }
    }
    
    /**
     * Set data
     */
    override func setData(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = TreatmentInfoRespBean(jsonString: data)
        if model.isSuccess() {
            _data = model
            _tblInfo.reloadData()
        } else {
            showAlert(message: model.message)
        }
    }
    
    // MARK: Logic
    /**
     * Request data
     */
    internal func requestData(action: Selector = #selector(setData(_:)),
                              isShowLoading: Bool = true) {
        TreatmentInfoRequest.request(
            action: action,
            view: self,
            id: _id,
            isShowLoading: isShowLoading)
    }
    
    /**
     * Reset data
     */
    private func resetData() {
    }
    
    /**
     * Handle refresh
     */
    internal func handleRefresh(_ sender: AnyObject) {
        self.resetData()
        requestData(action: #selector(finishHandleRefresh(_:)))
    }
    
    /**
     * Handle finish refresh
     */
    internal func finishHandleRefresh(_ notification: Notification) {
        setData(notification)
        refreshControl.endRefreshing()
    }
    
    /**
     * Set value of id
     * - parameter id: Customer id
     */
    public func setId(id: String) {
        self._id = id
    }
    
    /**
     * Handle request update data
     */
    internal func requestUpdate() {
        var arrData = [String]()
        for item in self._data.data.getData() {
            if item.id == DomainConst.ITEM_HEALTHY {
                for child in item.data {
                    arrData.append(child.id)
                }
            }            
        }
        let healthy = String.init(format: "%@%@%@", "[", arrData.joined(separator: ","), "]")
        TreatmentUpdateRequest.request(
            action: #selector(finishUpdate(_:)),
            view: self,
            id: self._id,
            diagnosis: self._data.data.getData(id: DomainConst.ITEM_DIAGNOSIS_ID)._dataStr,
            pathological: self._data.data.getData(id: DomainConst.ITEM_PATHOLOGICAL_ID)._dataStr,
            healthy: healthy,
            status: self._data.data.getData(id: DomainConst.ITEM_STATUS)._dataStr)
    }
    
    internal func finishUpdate(_ notification: Notification) {
        let data = notification.object as! String
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            requestData()
        }
    }
    
    /**
     * Get data by id
     * - parameter id: Id of data
     * - returns: Object data
     */
    public func getData(id: String) -> ConfigExtBean {
        return self._data.data.getData(id: id)
    }
    
    /**
     * Handle select diagnosis
     * - parameter title: Title of screen
     */
    public func createSelectScreenDiagnosis(title: String) {
        if self._data.data.getData(
            id: DomainConst.ITEM_DIAGNOSIS_ID)._dataStr.isEmpty {
            openScreenDiagnosis(title: title)
        } else {
            showAlert(message: "Bạn chắc chắn muốn cập nhật thông tin \"\(title)\" không?", okHandler: {
                alert in
                self.openScreenDiagnosis(title: title)
            }, cancelHandler: {
                alert in
                // Do nothing
            })
        }
    }
    
    public func openScreenDiagnosis(title: String) {
        let view = G01F02S03VC(nibName: G01F02S03VC.theClassName, bundle: nil)
        view.createNavigationBar(title: title)
        view.setData(data: LoginBean.shared.getDiagnosisConfigs(),
                     selectedValue: self._data.data.getData(
                        id: DomainConst.ITEM_DIAGNOSIS_ID)._dataStr)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
    }
    
    /**
     * Handle select pathological
     * - parameter title: Title of screen
     */
    public func createSelectScreenPathological(title: String) {
        let view = G01F02S04VC(nibName: G01F02S04VC.theClassName, bundle: nil)
        view.createNavigationBar(title: title)
        view.setData(data: LoginBean.shared.pathological,
                     selectedValue: self._data.data.getData(
                        id: DomainConst.ITEM_PATHOLOGICAL_ID)._dataStr)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
    }
    
    /**
     * Handle show healthy information
     */
    public func openHealthyInfo() {
        let view = G01F02S05VC(nibName: G01F02S05VC.theClassName,
                               bundle: nil)
        view.setData(id: self._id,
                     data: self.getData(id: DomainConst.ITEM_HEALTHY).data,
                     diagnosisId: self.getData(id: DomainConst.ITEM_DIAGNOSIS_ID)._dataStr,
                     pathologicalId: self.getData(id: DomainConst.ITEM_PATHOLOGICAL_ID)._dataStr,
                     status: self.getData(id: DomainConst.ITEM_STATUS)._dataStr)
        view.createNavigationBar(title: self.getData(id: DomainConst.ITEM_HEALTHY).name)
        
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
    }
    
    /**
     * Handle show treatment schedule detail
     * - parameter bean: Detail data
     */
    public func openTreatmentScheduleDetail(bean: ConfigExtBean) {
        let view = G01F03S01VC(nibName: G01F03S01VC.theClassName,
                               bundle: nil)
        view.createNavigationBar(title: bean.id)
        view.setData(bean: bean._dataExt, treatmentId: self._id)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(
                view, animated: true)
        }
    }
    
    internal func addNew(_ sender: AnyObject) {
        openCreateTreatmentScheduleDetail()
    }
    
    /**
     * Open create treatment schedule detail screen
     */
    func openCreateTreatmentScheduleDetail() -> Void {
        let view = G01F03S03VC(nibName: G01F03S03VC.theClassName,
                               bundle: nil)
        let data = self.getData(id: DomainConst.ITEM_DETAILS)._dataExt
        if !data.isEmpty {
            var copyArr = [ConfigExtBean]()
            for item in data[0]._dataExt {
                let copyData = ConfigExtBean(copy: item)
                copyArr.append(copyData)
            }
            
            view.setData(bean: copyArr,
                         scheduleId: self._id)
            view.resetData()
        }
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(
                view, animated: true)
        }
    }
    
    /**
     * Check if current treatment schedule is in completed status
     * - returns: True if value of status item is Completed, False otherwise
     */
    internal func isCompleted() -> Bool {
        return (self._data.data.getData(id: DomainConst.ITEM_STATUS)._dataStr
            == DomainConst.TREATMENT_SCHEDULE_COMPLETED)
    }
    
    /**
     * Check if current treatment schedule is in schedule status
     * - returns: True if value of status item is Schedule, False otherwise
     */
    internal func isSchedule() -> Bool {
        return (self._data.data.getData(id: DomainConst.ITEM_STATUS)._dataStr
            == DomainConst.TREATMENT_SCHEDULE_SCHEDULE)
    }
    
    /**
     * Check if current treatment schedule can update data
     * - returns: True if value of can_update item is 1, False otherwise
     */
    internal func canUpdate() -> Bool {
        return self._data.data.getData(id: DomainConst.ITEM_CAN_UPDATE)._dataStr.isON()
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
//        _tblInfo.rowHeight = UITableViewAutomaticDimension
//        _tblInfo.estimatedRowHeight = 150
        _tblInfo.addSubview(refreshControl)
    }
}

// MARK: Protocol - UITableViewDataSource
extension G01F02S02VC: UITableViewDataSource {
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
            return self._data.data.count()
        } else {
            return getData(id: DomainConst.ITEM_DETAILS)._dataExt.count
        }
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row > self._data.data.count() {
                return UITableViewCell()
            }
            let data = self._data.data.getData()[indexPath.row]
            var imagePath = DomainConst.INFORMATION_IMG_NAME
            if let img = DomainConst.VMD_IMG_LIST[data.id] {
                imagePath = img
            }
            let image = ImageManager.getImage(named: imagePath,
                                              margin: GlobalConst.MARGIN * 2)
            switch data.id {
            case DomainConst.ITEM_HEALTHY:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.accessoryType = .detailDisclosureButton
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            case DomainConst.ITEM_CAN_UPDATE,
                 DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_DIAGNOSIS_ID,
                 DomainConst.ITEM_PATHOLOGICAL_ID,
                 DomainConst.ITEM_DIAGNOSIS,
                 DomainConst.ITEM_DETAILS:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.contentView.isHidden = true
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
        case 1:     // Section Treatment schedule detail
            let data = getData(id: DomainConst.ITEM_DETAILS)._dataExt[indexPath.row]
            let status = data.getData(id: DomainConst.ITEM_STATUS)
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = data.id
            cell.textLabel?.font = GlobalConst.BASE_FONT
            cell.detailTextLabel?.text = data.name
            cell.detailTextLabel?.font = GlobalConst.BASE_BOLD_FONT
            if data.name.isEmpty && self.canUpdate() {
                cell.detailTextLabel?.text = LoginBean.shared.getUpdateText()
                cell.detailTextLabel?.textColor = UIColor.red
            }
            cell.accessoryType = .disclosureIndicator
            var imgPath = DomainConst.BLANK
            let imgMargin = GlobalConst.MARGIN * 2
            if status == DomainConst.TREATMENT_SCHEDULE_DETAIL_SCHEDULE
                || status == DomainConst.TREATMENT_SCHEDULE_DETAIL_ACTIVE {
                imgPath = DomainConst.VMD_STATUS_SCHEDULE_ICON_IMG_NAME
            } else if status == DomainConst.TREATMENT_SCHEDULE_DETAIL_COMPLETED {
                imgPath = DomainConst.VMD_STATUS_TREATMENT_ICON_IMG_NAME
            }
            cell.imageView?.image = ImageManager.getImage(
                named: imgPath, margin: imgMargin)
            cell.imageView?.contentMode = .scaleAspectFit
            return cell
        default:
            break
        }
        
        return UITableViewCell()        
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F02S02VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row > self._data.data.count() {
                return
            }
            let data = self._data.data.getData()[indexPath.row]
            switch data.id {
            case DomainConst.ITEM_DIAGNOSIS:
                if self.canUpdate() {
                    self.createSelectScreenDiagnosis(title: data.name)
                }                
            case DomainConst.ITEM_PATHOLOGICAL:
                if self.canUpdate() {
                    self.createSelectScreenPathological(title: data.name)
                }
            case DomainConst.ITEM_HEALTHY:
                self.openHealthyInfo()
            default:
                break
            }
            break
        case 1:
            let data = getData(id: DomainConst.ITEM_DETAILS)._dataExt[indexPath.row]
            self.openTreatmentScheduleDetail(bean: data)
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
            switch self._data.data.getData()[indexPath.row].id {
            case DomainConst.ITEM_CAN_UPDATE, DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_DIAGNOSIS_ID, DomainConst.ITEM_PATHOLOGICAL_ID,
                 DomainConst.ITEM_DIAGNOSIS,
                 DomainConst.ITEM_DETAILS:
                return 0
            case DomainConst.ITEM_END_DATE:
                if self.isCompleted() {
                    return UITableViewAutomaticDimension
                } else {
                    return 0
                }
            default:
                return UITableViewAutomaticDimension
            }
        case 1:
            return UITableViewAutomaticDimension
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let header = CustomerInfoHeaderView.init(
            frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: HEADER_HEIGHT))
        header.setHeader(bean: self.getData(id: DomainConst.ITEM_DETAILS),
                         actionText: DomainConst.CONTENT00065)
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return HEADER_HEIGHT
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F02S02VC: CustomerInfoHeaderViewDelegate {    
    func customerInfoHeaderViewDidSelect(object: ConfigExtBean) {
        switch object.id {
        case DomainConst.ITEM_DETAILS:
            self.addNew(self)
        default:
            break
        }
    }
}
