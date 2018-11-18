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
        createNavigationBar(title: "Báo cáo ngày " + strDate)
        btnOK.drawRadius(4)
        btnRefuse.drawRadius(4, color: "007AFF".hexColor(), thickness: 0.5)
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UINib(nibName: cellID, bundle: Bundle.main), forCellReuseIdentifier: cellID)
        tbView.reloadData()
        let status = report.getData(id: DomainConst.ITEM_STATUS)
        if status == DomainConst.REPORT_STATUS_CONFIRM {
            btnOK.isHidden = true
            btnRefuse.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Service
    /**
     *  call api update report status
     *  param: string status id
     */
    func updateReportStatus(_ statusID: String) {
        let req = UpdateDailyReportRequest()
        req.id = report.id
        req.status = statusID
        serviceInstance.updateReportStatus(req: req, success: { (result) in
            NotificationCenter.default.post(name: NSNotification.Name.init(G03Const.SHOULD_RELOAD_DATA_NOTI_NAME), object: nil)
            self.showAlert(message: result.message, okHandler: { (action) in
                
            })
            self.report = result.data
            self.tbView.reloadData()
        }) { (error) in
            self.showAlert(message: error.message)
        }
    }
    
    //MARK: - Logic
    
    //MARK: - IBAction
    @IBAction func btnOkAction(_ sender: Any) {
        updateReportStatus(DomainConst.REPORT_STATUS_CONFIRM)
    }
    @IBAction func btnRefuseAction(_ sender: Any) {
        updateReportStatus(DomainConst.REPORT_STATUS_CANCEL)
    }
    
}

extension G03F00S03VC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (report != nil) {
            return report.getListData().count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = report.getListData()[indexPath.row]
        if item.name.count > 0 {
            return UITableViewAutomaticDimension
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > report.getListData().count {
            return UITableViewCell()
        }
        let item = report.getListData()[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        if item.name.count > 0 {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
        cell.textLabel?.text = item.name
        cell.textLabel?.font = GlobalConst.BASE_FONT
        cell.detailTextLabel?.text = item.getStringData()
        cell.detailTextLabel?.font = GlobalConst.BASE_FONT
        var imgPath = DomainConst.INFORMATION_IMG_NAME
        let imgMargin = GlobalConst.MARGIN * 2
        if let img = DomainConst.VMD_IMG_LIST[item.id] {
            imgPath = img
        }
        let img = ImageManager.getImage(named: imgPath,
                                          margin: imgMargin)
        cell.imageView?.image = img
        cell.imageView?.contentMode = .scaleAspectFit
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.contentView.clipsToBounds = true
        return cell
    }
}

extension G03F00S03VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = report.getListData()[indexPath.row]
        if item.id == DomainConst.ITEM_TOTAL {
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












