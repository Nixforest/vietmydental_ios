//
//  G01F02S01VC.swift
//  dental
//
//  Created by SPJ on 2/17/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F02S01VC: ChildExtViewController {
    // MARK: Properties
    /** Customer id */
    var _id:                String                  = DomainConst.BLANK
    /** Data */
    var _data:              TreatmentListRespBean   = TreatmentListRespBean()
    /** Information table view */
    var _tblInfo:           UITableView             = UITableView()
    /** Current page */
    var _page:              Int                     = 0
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
        createRightNavigationItem(title: "+", action: #selector(addNew(_:)),
                                  target: self)
        createInfoTableView()
        self.view.addSubview(_tblInfo)
        requestData()
    }
    
    /**
     * Notifies the view controller that its view was added to a view hierarchy.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _data.clearData()
        requestData(action: #selector(setData(_:)), isShowLoading: false)
    }
    
    /**
     * Set data
     */
    override func setData(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = TreatmentListRespBean(jsonString: data)
        if model.isSuccess() {
            _data.updateData(bean: model.data)
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
        TreatmentListRequest.request(action: action,
                                     view: self,
                                     page: String(self._page),
                                     id: self._id,
                                     isShowLoading: isShowLoading)
    }
    
    /**
     * Reset data
     */
    private func resetData() {
        _data.clearData()
        // Reset current search value
        self._page      = 0
        // Reload table
        _tblInfo.reloadData()
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
     * Open detail screen
     * - parameter id:      Id of treatment schedule
     */
    internal func openDetail(id: String) {
        let view = G01F02S02VC(nibName: G01F02S02VC.theClassName,
                               bundle: nil)
        view.setId(id: id)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
    }
    
    internal func addNew(_ sender: AnyObject) {
        openCreateTreatmentSchedule()
    }
    
    /**
     * Open create treatment schedule screen
     */
    func openCreateTreatmentSchedule() -> Void {
        let view = G01F02S06VC(nibName: G01F02S06VC.theClassName,
                               bundle: nil)
        view.setData(customerId: self._id)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(
                view, animated: true)
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
        _tblInfo.rowHeight = UITableViewAutomaticDimension
        _tblInfo.estimatedRowHeight = 150
        _tblInfo.addSubview(refreshControl)
    }
}

// MARK: Protocol - UITableViewDataSource
extension G01F02S01VC: UITableViewDataSource {
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
        return self._data.getList().count
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > self._data.getList().count {
            return UITableViewCell()
        }
        let data = self._data.getList()[indexPath.row]
        let treatment = TreatmentBean(jsonData: data._dataObj)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = treatment.start_date
        cell.textLabel?.font = GlobalConst.BASE_FONT
        cell.detailTextLabel?.text = data.name
        cell.detailTextLabel?.font = GlobalConst.BASE_FONT
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        var imgPath = DomainConst.BLANK
        let imgMargin = GlobalConst.MARGIN * 2
        if treatment.status == DomainConst.TREATMENT_SCHEDULE_SCHEDULE {
            imgPath = DomainConst.VMD_STATUS_SCHEDULE_ICON_IMG_NAME
        } else if treatment.status == DomainConst.TREATMENT_SCHEDULE_COMPLETED {
            imgPath = DomainConst.VMD_STATUS_TREATMENT_ICON_IMG_NAME
        }
        cell.imageView?.image = ImageManager.getImage(
            named: imgPath, margin: imgMargin)
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F02S01VC: UITableViewDelegate {    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /**
     * Tells the delegate the table view is about to draw a cell for a particular row.
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Total page does not 1
        if _data.data.getTotalPage() != 1 {
            let lastElement = _data.getList().count - 1
            // Current is the last element
            if indexPath.row == lastElement {
                self._page += 1
                // Page less than total page
                if self._page <= _data.data.getTotalPage() {
                    self.requestData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self._data.getList().count > indexPath.row {
            self.openDetail(id: self._data.getList()[indexPath.row].id)
        }
    }
}
