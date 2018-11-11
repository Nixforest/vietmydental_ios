//
//  G01F00S02VC.swift
//  dental
//
//  Created by SPJ on 2/2/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F00S02VC: ChildExtViewController {
    // MARK: Properties
    /** Data */
    var _data:              CustomerInfoRespBean    = CustomerInfoRespBean()
    /** Customer id */
    var _id:                String                  = DomainConst.BLANK
    /** Customer id */
    var shouldSaveCustomer: Bool                    = false
    /** Customer qr code */
    var _code:              String                  = DomainConst.BLANK
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
        self.createNavigationBar(title: DomainConst.CONTENT00543)
        createInfoTableView()
        self.view.addSubview(_tblInfo)
        requestData()
    }
    
    /**
     * Notifies the view controller that its view was added to a view hierarchy.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestData(action: #selector(setData(_:)),
                    isShowLoading: false)
    }
    
    /**
     * Set data
     */
    override func setData(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = CustomerInfoRespBean(jsonString: data)
        if model.isSuccess() {
            _data = model
            _tblInfo.reloadData()
            if shouldSaveCustomer {
                self.saveCustomerQRCode()
            }
        } else {
            showAlert(message: model.message)
        }
    }
    
    func saveCustomerQRCode() {
        var name = ""
        for item in _data.data {
            if item.id == "1" {
                for child in item.data {
                    if child.id == "1" {
                        name = child.name
                    }
                }
            }
        }
        app.saveCustomer(id: self._id, name: name, code: self._code)
    }
    
    // MARK: Logic
    /**
     * Request data
     */
    internal func requestData(action: Selector = #selector(setData(_:)),
                              isShowLoading: Bool = true) {
        CustomerInfoRequest.request(
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
     * Set value of id and qr code
     * - parameter id: Customer id, customer qr code
     */
    public func setId(id: String, code: String) {
        _id = id
        _code = code
    }
    
    /**
     * Handle open Medical record info screen
     * - parameter id:  Customer id
     * - parameter title:  Screen title
     */
    func openMedicalRecordInfo(id: String, title: String) {
        let view = G01F01S01VC(nibName: G01F01S01VC.theClassName,
                               bundle: nil)
        view.setId(id: id)
        view.createNavigationBar(title: title)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
//        let view = G01F01S01ExtVC(nibName: G01F01S01ExtVC.theClassName,
//                               bundle: nil)
//        view.setId(id: self._id)
//        view.createNavigationBar(title: title)
//        if let controller = BaseViewController.getCurrentViewController() {
//            controller.navigationController?.pushViewController(view,
//                                                                animated: true)
//        }
    }
    
    /**
     * Handle open Treatment detail screen
     * - parameter id:  Treatment schedules id
     */
    func openTreatmentDetail(id: String) {
        let view = G01F02S02VC(nibName: G01F02S02VC.theClassName,
                               bundle: nil)
        view.setId(id: id)
//        view.createNavigationBar(title: title)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
    }
    
    /**
     * Handle open Create new treatment schedule screen
     */
    func addNewTreatmentSchedule() -> Void {
        let view = G01F02S06VC(nibName: G01F02S06VC.theClassName,
                               bundle: nil)
        view.setData(customerId: self._id)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(
                view, animated: true)
        }
    }
    
    /**
     * Handle open Treatment history screen
     */
    func openTreatmentHistory(title: String) {
        let view = G01F02S01VC(nibName: G01F02S01VC.theClassName,
                               bundle: nil)
        view.setId(id: self._id)
        view.createNavigationBar(title: title)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
    }
    
    /**
     * Handle open Medical history
     */
    func openMedicalHistory() {
        let view = G01F01S02VC(nibName: G01F01S02VC.theClassName,
                               bundle: nil)
        for item in self._data.data {
            if item.id == DomainConst.GROUP_MEDICAL_RECORD {
                for child in item._dataExt {
                    if child.id == DomainConst.ITEM_MEDICAL_HISTORY {
                        view.setData(id: self._id, recordNumber: self.getData(id: DomainConst.ITEM_RECORD_NUMBER, groupId: DomainConst.GROUP_MEDICAL_RECORD), data: child.data)
                        view.createNavigationBar(title: child.name)
                    }
                }
            }
        }
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
    }
    
    /**
     * Get data from id
     * - parameter id:      Id of data
     * - parameter groupId: Group id of data
     * - returns:           Value of data
     */
    public func getData(id: String, groupId: String) -> String {
        for item in self._data.data {
            if item.id == groupId {
                for child in item._dataExt {
                    if child.id == id {
                        return child.name
                    }
                }
            }
        }
        return DomainConst.BLANK
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
        _tblInfo.addSubview(refreshControl)
    }
}

// MARK: Protocol - UITableViewDataSource
extension G01F00S02VC: UITableViewDataSource {
    /**
     * Asks the data source to return the number of sections in the table view.
     * - returns: 1 section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self._data.data.count
    }
    
    /**
     * Tells the data source to return the number of rows in a given section of a table view.
     * - returns: List information count
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._data.data[section]._dataExt.count
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionId = self._data.data[indexPath.section].id
        if indexPath.row > self._data.data[indexPath.section]._dataExt.count {
            return UITableViewCell()
        }
        let data = self._data.data[indexPath.section]._dataExt[indexPath.row]
        let imgMargin = GlobalConst.MARGIN * 2
        switch sectionId {
        case DomainConst.GROUP_MEDICAL_RECORD:
            var imagePath = DomainConst.INFORMATION_IMG_NAME
            if let img = DomainConst.VMD_IMG_LIST[data.id] {
                imagePath = img
            }
            let image = ImageManager.getImage(named: imagePath,
                                              margin: imgMargin)
            switch data.id {
            case DomainConst.ITEM_NAME:                
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.text = data._dataStr
                cell.detailTextLabel?.font = GlobalConst.SMALL_FONT
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            case DomainConst.ITEM_BIRTHDAY:                
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.text = data._dataStr
                cell.detailTextLabel?.font = GlobalConst.SMALL_FONT
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            case DomainConst.ITEM_MEDICAL_HISTORY:                
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFit
                cell.accessoryType = .detailDisclosureButton
                return cell
            case DomainConst.ITEM_UPDATE_DATA:                
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFit
                cell.accessoryType = .disclosureIndicator
                return cell
            default:
                break
            }
        case DomainConst.GROUP_TREATMENT:
            switch data.id {
            case DomainConst.ITEM_UPDATE_DATA:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.imageView?.image = ImageManager.getImage(
                    named: DomainConst.VMD_ADD1_ICON_IMG_NAME, margin: imgMargin)
                cell.imageView?.contentMode = .scaleAspectFit
                cell.accessoryType = .disclosureIndicator
                return cell
            default:
                let treatment = TreatmentBean(jsonData: data._dataObj)
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                cell.textLabel?.text = treatment.start_date
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.text = data.name
                cell.detailTextLabel?.font = GlobalConst.BASE_FONT
                var imgPath = DomainConst.BLANK
                if treatment.status == DomainConst.TREATMENT_SCHEDULE_SCHEDULE {
                    imgPath = DomainConst.VMD_STATUS_SCHEDULE_ICON_IMG_NAME
                } else if treatment.status == DomainConst.TREATMENT_SCHEDULE_COMPLETED {
                    imgPath = DomainConst.VMD_STATUS_TREATMENT_ICON_IMG_NAME
                }
                
                cell.imageView?.image = ImageManager.getImage(
                    named: imgPath, margin: imgMargin)
                cell.imageView?.contentMode = .scaleAspectFit
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        default: break
        }
        
        return UITableViewCell()
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F00S02VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionId = self._data.data[indexPath.section].id
        if indexPath.row > self._data.data[indexPath.section]._dataExt.count {
            return
        }
        let data = self._data.data[indexPath.section]._dataExt[indexPath.row]
        switch sectionId {
        case DomainConst.GROUP_MEDICAL_RECORD:          // Medical record group
            switch data.id {
            case DomainConst.ITEM_MEDICAL_HISTORY:      // View medical history
                openMedicalHistory()
                break
            case DomainConst.ITEM_UPDATE_DATA:          // Update data
                openMedicalRecordInfo(id: self._id, title: self._data.data[indexPath.section].name)
                break
            default: break
            }
        case DomainConst.GROUP_TREATMENT:               // Treatment group
            switch data.id {
            case DomainConst.ITEM_UPDATE_DATA:          // Add new treatment schedule
                addNewTreatmentSchedule()
                break
            default:                                    // View detail info
                openTreatmentDetail(id: data.id)        
            }
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CustomerInfoHeaderView.init(
            frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: HEADER_HEIGHT))
        header.setHeader(bean: _data.data[section])
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }
    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F00S02VC: CustomerInfoHeaderViewDelegate {    
    func customerInfoHeaderViewDidSelect(object: ConfigExtBean) {
        switch object.id {
        case DomainConst.GROUP_MEDICAL_RECORD:
            openMedicalRecordInfo(id: self._id, title: object.name)
        case DomainConst.GROUP_TREATMENT:
            openTreatmentHistory(title: object.name)
            break
        default:
            break
        }
    }
}
