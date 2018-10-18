//
//  G03F00S01ExtVC.swift
//  dental
//
//  Created by Pham Trung Nguyen on 10/18/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G03F00S01ExtVC: BaseParentViewController {
    /** Information table view */
    var _tblInfo:           UITableView             = UITableView()
    /** Data */
    var _data:              DailyReportRespBean         = DailyReportRespBean()
    /** Refrest control */
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    /** Month index */
    var monthIdx:           Int                     = 0

    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createNavigationBar(title: DomainConst.CONTENT00578)
        createInfoTableView()
        self.view.addSubview(_tblInfo)
        requestData(completionHandler: loadData)
    }
    
    // MARK: Logic
    /**
     * Request data
     * - add param strDate for function search by date
     */
    internal func requestData(completionHandler: ((Any?) -> Void)?) {
        GetDailyReportRequest.request(view: self, month: self.getMonthValue(), completionHandler: completionHandler)
    }
    
    /**
     * Reset data
     */
    private func resetData() {
        _data.data.removeAll()
        // Reset current search value
        self.monthIdx      = 0
        // Reload table
        _tblInfo.reloadData()
    }
    
    /**
     * Handle refresh
     */
    internal func handleRefresh(_ sender: AnyObject) {
        self.resetData()
        requestData(completionHandler: finishHandleRefresh)
    }
    
    /**
     * Handle finish refresh
     */
    internal func finishHandleRefresh(_ model: Any?) {
        finishRequest(model)
        refreshControl.endRefreshing()
    }
    
    /**
     * Handle finish request
     */
    override func finishRequest(_ model: Any?) {
        let data = model as! String
        let model = DailyReportRespBean(jsonString: data)
        if model.isSuccess() {
            self._data = model
            _tblInfo.reloadData()
        } else {
            showAlert(message: model.message)
        }
    }
    
    /**
     * Handle finish request
     */
    func loadData(_ model: Any?) {
        let data = model as! String
        let model = DailyReportRespBean(jsonString: data)
        if model.isSuccess() {
            self._data = model
            _tblInfo.reloadData()
        } else {
            showAlert(message: model.message)
        }
    }
    
    /**
     * Get month value for request parameter
     * - returns: Value of month as string
     */
    internal func getMonthValue() -> String {
        let curDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DomainConst.DATE_TIME_FORMAT_3
        let monthValue = curDate.adding(Calendar.Component.month, value: -self.monthIdx)
        return formatter.string(from: monthValue)
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
extension G03F00S01ExtVC: UITableViewDataSource {
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
        return self._data.data.count()
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self._data.data.getData()[indexPath.row]
        let listChildData = ListConfigBean.init(jsonData: data._dataArrObj)
        var imagePath = DomainConst.INFORMATION_IMG_NAME
        if let img = DomainConst.VMD_IMG_LIST[data.id] {
            imagePath = img
        }
        let image = ImageManager.getImage(named: imagePath,
                                          margin: GlobalConst.MARGIN * 2)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = data.name
        cell.textLabel?.font = GlobalConst.BASE_FONT
        cell.detailTextLabel?.text = listChildData.getData(id: DomainConst.ITEM_STATUS_STR)._dataStr
        cell.detailTextLabel?.font = GlobalConst.BASE_FONT
//        cell.accessoryType = .detailDisclosureButton
        cell.imageView?.image = image
        cell.imageView?.contentMode = .scaleAspectFit
        return cell
    }
}

// MARK: Protocol - UITableViewDelegate
extension G03F00S01ExtVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
