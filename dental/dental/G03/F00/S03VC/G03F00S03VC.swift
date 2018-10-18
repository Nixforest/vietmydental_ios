//
//  G03F00S03VC.swift
//  dental
//
//  Created by Lâm Phạm on 10/8/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G03F00S03VC: ChildExtViewController {

    
    @IBOutlet weak var btnRefuse: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var tbView: UITableView!
    
    var report: ConfigExtBean!
    var strDate: String = ""
    let cellID = "G03F00S03TableViewCell"
    
    /**
     *  Init with param
     * report: - report of agent
     * date: - date of report
     */
    init(withReport report: ConfigExtBean, ofDate strDate: String) {
        self.report = report
        self.strDate = strDate
        super.init(nibName: "G03F00S03VC", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: report.name)
        btnOK.drawRadius(4)
        btnRefuse.drawRadius(4, color: "007AFF".hexColor(), thickness: 0.5)
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UINib(nibName: cellID, bundle: Bundle.main), forCellReuseIdentifier: cellID)
        tbView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Service
    func updateReportStatus(_ statusID: String) {
        let req = UpdateDailyReportRequest()
        req.id = report.id
        req.status = statusID
        serviceInstance.updateReportStatus(req: req, success: { (result) in
            NotificationCenter.default.post(name: NSNotification.Name.init("G03F00S02VC_SHOULD_RELOAD_DATA"), object: nil)
            self.showAlert(message: result.message, okHandler: { (action) in
                
            })
        }) { (error) in
            self.showAlert(message: error.message)
        }
    }
    
    //MARK: - Logic
    
    //MARK: - IBAction
    @IBAction func btnOkAction(_ sender: Any) {
        updateReportStatus(DomainConst.REPORT_STATUS_APPROVED)
    }
    @IBAction func btnRefuseAction(_ sender: Any) {
        updateReportStatus(DomainConst.REPORT_STATUS_REFUSE)
    }
    
}

extension G03F00S03VC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return report.getListData().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = report.getListData()[indexPath.row]
        if item.name.count > 0 {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! G03F00S03TableViewCell
        cell.selectionStyle = .none
        cell.loadData(report.getListData()[indexPath.row])
        return cell
    }
}

extension G03F00S03VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = report.getListData()[indexPath.row]
        if item.id == DomainConst.ITEM_RECEIPT_TOTAL {
            let request = GetStatisticsRequest()
            for item in report.getListData() {
                if item.id == DomainConst.ITEM_RECEIPT_AGENT_ID {
                    request.agent_id = "[\(item.getStringData())]"
                    break
                }
            }
            if let date = CommonProcess.getDate(fromString: self.strDate, withFormat: DomainConst.DATE_TIME_FORMAT_1) {
                let strDate = CommonProcess.getDateString(date: date, format: DomainConst.DATE_TIME_FORMAT_2)
                request.date_from = strDate
                request.date_to = strDate
                let vc = StatisticsDetailViewController.init(paramRequest: request)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.showAlert(message: "Wrong date format")
            }
        }
    }
}












