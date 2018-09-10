//
//  G01F02S05VC.swift
//  dental
//
//  Created by SPJ on 2/18/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F02S05VC: ChildExtViewController {
    // MARK: Properties
    /** Treatment id */
    var _id:                String                  = DomainConst.BLANK
    /** Diagnosis id */
    var _diagnosisId:       String                  = DomainConst.BLANK
    /** Pathological id */
    var _pathologicalId:    String                  = DomainConst.BLANK
    /** Status */
    var _status:            String                  = DomainConst.BLANK
    /** Data */
    var _data:              [ConfigBean]            = [ConfigBean]()
    /** Information table view */
    var _tblInfo:           UITableView             = UITableView()
    
    // MARK: Static values
    // MARK: Constant    
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createRightNavigationItem(title: "+", action: #selector(addNew(_:)),
                                  target: self)
        createInfoTableView()
        self.view.addSubview(_tblInfo)
    }
    
    /**
     * Notifies the view controller that its view was added to a view hierarchy.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check temp value is not empty
        if !BaseModel.shared.sharedString.isEmpty {
            // Loop for all pathological config
            for item in LoginBean.shared.pathological {
                // Match id
                if BaseModel.shared.sharedString == item.id {
                    // Check if temp value is not exist in current data
                    if !isExist(id: BaseModel.shared.sharedString) {
                        // Add new
                        self._data.append(item)
                        requestUpdate(isShowLoading: false)
                    }                    
                    break
                }
            }
        }
        BaseModel.shared.sharedString = DomainConst.BLANK
    }
    
    /**
     * Set data
     */
    override func setData(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            _tblInfo.reloadData()
        } else {
            showAlert(message: model.message)
        }
    }
    
    // MARK: Logic
    /**
     * Set value of id
     * - parameter id: Customer id
     */
    public func setId(id: String) {
        self._id = id
    }
    
    /**
     * Set data for screen
     * - parameter id:              Customer id
     * - parameter data:            List data
     * - parameter diagnosisId:     Diagnosis id
     * - parameter pathologicalId:  Pathological id
     * - parameter status:          Status
     */
    public func setData(id: String,
                        data: [ConfigBean],
                        diagnosisId: String,
                        pathologicalId: String,
                        status: String) {
        setId(id: id)
        self._data = data
        self._diagnosisId = diagnosisId
        self._pathologicalId = pathologicalId
        self._status = status
    }
    
    /**
     * Handle remove pathological from tableview
     * - parameter idx: Index of pathological in table view
     */
    public func removePathological(idx: Int) {
        self._data.remove(at: idx)
        
        requestUpdate(isShowLoading: false)
    }
    
    internal func addNew(_ sender: AnyObject) {
        let view = G01F01S03VC(nibName: G01F01S03VC.theClassName, bundle: nil)
        view.createNavigationBar(title: DomainConst.CONTENT00548)
        view.setData(data: LoginBean.shared.pathological, selectedValue: "")
        view.setSelectedArray(value: self._data)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
    }
    
    /**
     * Handle request update data
     */
    internal func requestUpdate(isShowLoading: Bool = true) {
        var arrData = [String]()
        for item in self._data {
            arrData.append(item.id)
        }
        let healthy = String.init(format: "%@%@%@", "[", arrData.joined(separator: ","), "]")
        TreatmentUpdateRequest.request(
            action: #selector(finishUpdate(_:)),
            view: self,
            id: self._id,
            diagnosis: self._diagnosisId,
            pathological: self._pathologicalId,
            healthy: healthy,
            status: self._status,
            isShowLoading: isShowLoading)
    }
    
    internal func finishUpdate(_ notification: Notification) {
        let data = notification.object as! String
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            self._tblInfo.reloadData()
        }
    }
    
    /**
     * Check an Id is exist in data
     * - parameter id: Id to check
     */
    func isExist(id: String) -> Bool {
        for item in self._data {
            if item.id == id {
                return true
            }
        }
        return false
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
extension G01F02S05VC: UITableViewDataSource {
    /**
     * Tells the data source to return the number of rows in a given section of a table view.
     * - returns: List information count
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._data.count
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > self._data.count {
            return UITableViewCell()
        }
        let data = self._data[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = data.name
        cell.textLabel?.font = GlobalConst.BASE_FONT
        return cell
    }
    
    /**
     * Asks the data source to verify that the given row is editable.
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {        
        return true
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F02S05VC: UITableViewDelegate {    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: DomainConst.CONTENT00547) { (action, indexPath) in
            self.showAlert(message: DomainConst.CONTENT00546,
                           okHandler: {
                            (alert: UIAlertAction!) in
                            self.removePathological(idx: indexPath.row)
            },
                           cancelHandler: {
                            (alert: UIAlertAction!) in
            })
        }
        return [delete]
    }
}
