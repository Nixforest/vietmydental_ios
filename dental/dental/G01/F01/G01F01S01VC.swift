//
//  G01F01S01VC.swift
//  dental
//
//  Created by SPJ on 2/16/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F01S01VC: ChildExtViewController {
    // MARK: Properties
    /** Data */
    var _data:              MedicalRecordRespBean   = MedicalRecordRespBean()
    /** Customer id */
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
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.createNavigationBar(title: DomainConst.CONTENT00544)
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
        let model = MedicalRecordRespBean(jsonString: data)
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
        MedicalRecordInfoRequest.request(
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
     * Get data from id
     * - parameter id:  Id of data
     * - returns:       Value of data
     */
    public func getData(id: String) -> String {
        for item in self._data.data {
            if item.id == id {
                return item.name
            }
        }
        return DomainConst.BLANK
    }
    
    /**
     * Set data from id
     * - parameter id:      Id of data
     * - parameter value:   Value of data
     */
    public func setData(id: String, value: String) {
        for item in self._data.data {
            if item.id == id {
                item.name = value
                break
            }
        }
    }
    
    /**
     * Create input alert
     * - parameter id:  Id of item
     */
    public func createInputAlert(id: String) {
        var title           = DomainConst.BLANK
        var message         = DomainConst.BLANK
        var placeHolder     = DomainConst.BLANK
        var keyboardType    = UIKeyboardType.default
        var value           = DomainConst.BLANK
        switch id {
        case DomainConst.ITEM_RECORD_NUMBER:
            title = DomainConst.CONTENT00549
            message = DomainConst.CONTENT00550
            value = getData(id: id)
        default:
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
                self.setData(id: id, value: newValue)
                self.requestUpdate(isShowLoading: false)
            } else {
                self.showAlert(message: DomainConst.CONTENT00551,
                               okHandler: {
                                alert in
                                self.createInputAlert(id: id)
                })
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     * Handle request update data
     */
    internal func requestUpdate(isShowLoading: Bool = true) {
        var arrData = [String]()
        for item in self._data.data {
            if item.id == DomainConst.ITEM_MEDICAL_HISTORY {
                for child in item.data {
                    arrData.append(child.id)
                }
            }            
        }
        let medicalHistory = String.init(format: "%@%@%@", "[", arrData.joined(separator: ","), "]")
        MedicalRecordUpdateRequest.request(
            action: #selector(finishUpdate(_:)),
            view: self,
            id: self._id,
            recordNumber: getData(id: DomainConst.ITEM_RECORD_NUMBER),
            medicalHistory: medicalHistory,
            isShowLoading: isShowLoading)
    }
    
    internal func finishUpdate(_ notification: Notification) {
        let data = notification.object as! String
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            self._tblInfo.reloadData()
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
        _tblInfo.addSubview(refreshControl)
    }
}

// MARK: Protocol - UITableViewDataSource
extension G01F01S01VC: UITableViewDataSource {
    /**
     * Asks the data source to return the number of sections in the table view.
     * - returns: 1 section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     * Tells the data source to return the number of rows in a given section of a table view.
     * - returns: List information count
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._data.data.count
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > self._data.data.count {
            return UITableViewCell()
        }
        let data = self._data.data[indexPath.row]
        var imagePath = DomainConst.INFORMATION_IMG_NAME
        if let img = DomainConst.VMD_IMG_LIST[data.id] {
            imagePath = img
        }
        let image = ImageManager.getImage(named: imagePath,
                                          margin: GlobalConst.MARGIN * 2)
        switch data.id {
        case DomainConst.ITEM_MEDICAL_HISTORY:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = data.name
            cell.textLabel?.font = GlobalConst.BASE_FONT
            cell.imageView?.image = image
            cell.imageView?.contentMode = .scaleAspectFit
            cell.accessoryType = .detailDisclosureButton
            return cell
        case DomainConst.ITEM_ADDRESS:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = data.name
            cell.textLabel?.font = GlobalConst.BASE_FONT
            cell.imageView?.image = image
            cell.imageView?.contentMode = .scaleAspectFit
            return cell
        case DomainConst.ITEM_RECORD_NUMBER:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            var value = data.name            
            if value.isEmpty {
                value = DomainConst.CONTENT00560
            }
            cell.textLabel?.text = value
            cell.textLabel?.textColor = UIColor.red
            cell.textLabel?.font = GlobalConst.BASE_FONT
            cell.imageView?.image = image
            cell.imageView?.contentMode = .scaleAspectFit
            return cell
        default:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = data.name
            cell.textLabel?.font = GlobalConst.BASE_FONT
            cell.imageView?.image = image
            cell.imageView?.contentMode = .scaleAspectFit
            return cell
        }
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F01S01VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > self._data.data.count {
            return
        }
        let data = self._data.data[indexPath.row]
        switch data.id {
        case DomainConst.ITEM_MEDICAL_HISTORY:
            let view = G01F01S02VC(nibName: G01F01S02VC.theClassName,
                                   bundle: nil)
            view.setData(id: self._id, recordNumber: self.getData(id: DomainConst.ITEM_RECORD_NUMBER), data: data.data)            
            view.createNavigationBar(title: data.name)
            if let controller = BaseViewController.getCurrentViewController() {
                controller.navigationController?.pushViewController(view,
                                                                    animated: true)
            }
        case DomainConst.ITEM_RECORD_NUMBER:
            createInputAlert(id: data.id)
        case DomainConst.ITEM_PHONE:
            self.makeACall(phone: data.name)
        case DomainConst.ITEM_ADDRESS:
            showAlert(message: data.name, title: DomainConst.CONTENT00088)
        default: break
        }
    }
    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self._data.data[indexPath.row].name.isEmpty) {
            if self._data.data[indexPath.row].id == DomainConst.ITEM_RECORD_NUMBER {
                return UITableViewAutomaticDimension
            }
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
    }
}
