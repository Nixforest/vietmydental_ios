//
//  G03F00S01VC.swift
//  dental
//
//  Created by Lâm Phạm on 10/3/18.
//  Copyright © 2018 SPJ. All rights reserved.
//
//  BUG0091

import UIKit
import harpyframework

class G03F00S01VC: BaseParentViewController {
    
    @IBOutlet weak var tbView: UITableView!
    
    let cellID = "G03F00S01TableViewCell"
    var shouldLoadMore: Bool = true
    var isRefreshData: Bool = false
    var refreshControl = UIRefreshControl()
    var monthCount: Int = 0
    var reportList: DailyReportList = DailyReportList()
    
    //MARK: - Life cirle
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Danh sách báo cáo")
        tbView.delegate = self
        tbView.dataSource = self
//        tbView.register(UINib(nibName: cellID, bundle: Bundle.main), forCellReuseIdentifier: cellID)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tbView.addSubview(refreshControl)
        getReportList(time: getParamDateString())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Logic
    @objc private func refreshData() {
        isRefreshData = true
        reportList.data.removeAll()
        monthCount = 0
        let strDate = getParamDateString()
        getReportList(time: strDate)
    }
    /** get parameter for request
     *  output: date string format yyyy/MM
     */
    func getParamDateString() -> String {
        let current = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DomainConst.DATE_TIME_FORMAT_3
        let dateNeedGetReport = current.adding(Calendar.Component.month, value: -monthCount)
        return formatter.string(from: dateNeedGetReport)
    }
    
    /** process data response based on month */
    func processData(_ list: DailyReportList) {
        // month data is empty, stop load more
        if list.data.count == 0 {
            shouldLoadMore = false
            monthCount = 0
            return
        }
        // month have data
        monthCount += 1
        shouldLoadMore = true
        self.reportList.data.append(contentsOf: list.data)
    }
    
    
    //MARK: - API
    /** call api get report list by month
     * input: date string format "yyyy-MM"
     */
    func getReportList(time: String) {
        if isRefreshData {
            refreshControl.beginRefreshing()
        } else {
            LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        }
        let req = DailyReportListRequest()
        req.month = time
        serviceInstance.getDailyReportList(req: req, success: { (data) in
            self.processData(data)
            if self.isRefreshData {
                self.isRefreshData = false
                self.refreshControl.endRefreshing()
            } else {
                LoadingView.shared.hideOverlayView(className: self.theClassName)
            }
            self.tbView.reloadData()
        }) { (error) in
            if self.isRefreshData {
                self.refreshControl.endRefreshing()
                self.isRefreshData = false
            } else {
                LoadingView.shared.hideOverlayView(className: self.theClassName)
            }
            self.showAlert(message: error.message)
            self.tbView.reloadData()
        }
    }
    /** get list agent report by day */
    func getDailyAgentReport(byDate date: String) {
        LoadingView.shared.showOverlay()
        let dailyReq = DailyReportRequest()
        dailyReq.date = date
        serviceInstance.getDailyReport(req: dailyReq, success: { (report) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            if report.data.count == 1 {
                let vc = G03F00S03VC.init(withReport: report.data[0], ofDate: date)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = G03F00S02VC(strDate: date)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }) { (error) in
            self.showAlert(message: error.message)
            LoadingView.shared.hideOverlayView(className: self.theClassName)
        }
    }
    
}

//MARK: - Extension
extension G03F00S01VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let report = reportList.data[indexPath.row]
        let stt = report.getData(id: DomainConst.ITEM_STATUS)
        if stt == DomainConst.REPORT_STATUS_NOT_CREATED_YET || stt == DomainConst.REPORT_STATUS_NEW {
            self.showAlert(message: "Báo cáo chưa được tạo bởi lễ tân")
            return
        }
        getDailyAgentReport(byDate: report.name)
    }
}

extension G03F00S01VC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportList.data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > reportList.data.count {
            return UITableViewCell()
        }
        let report = reportList.data[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = report.name
        cell.textLabel?.font = GlobalConst.BASE_FONT
        for data in report.getListData() {
            switch data.id {
            case DomainConst.ITEM_STATUS_STR:
                cell.detailTextLabel?.text = data.getStringData()
                cell.detailTextLabel?.font = GlobalConst.BASE_FONT
            case DomainConst.ITEM_STATUS:
                let imgMargin = GlobalConst.MARGIN
                let stt = DailyReportStatus.getStatus(byID: data.getStringData())
                let img = stt.getImage().imageWithInsets(insets: UIEdgeInsets(top: imgMargin, left: imgMargin, bottom: imgMargin, right: imgMargin))
                cell.imageView?.image = img
                break
            default:
                break
            }
        }
        cell.imageView?.contentMode = .scaleAspectFit
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if shouldLoadMore {
            if indexPath.row == reportList.data.count - 1 {
                let strDate = getParamDateString()
                getReportList(time: strDate)
            }
        }
    }
}











