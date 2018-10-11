//
//  G03F00S02VC.swift
//  dental
//
//  Created by Lâm Phạm on 10/4/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G03F00S02VC: ChildExtViewController {

    @IBOutlet weak var tbView: UITableView!
    
    let cellID = "G03F00S01TableViewCell"
    var req: DailyReportRequest!
    var agentReportList: DailyReport = DailyReport()
    var shouldLoadData: Bool = true
    
    //MARK: - Life circle
    init(strDate: String) {
        req = DailyReportRequest()
        req.date = strDate
        super.init(nibName: "G03F00S02VC", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Báo cáo ngày \(req.date)")
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UINib(nibName: cellID, bundle: Bundle.main), forCellReuseIdentifier: cellID)
        NotificationCenter.default.addObserver(self, selector: #selector(shouldReloadData), name: NSNotification.Name("G03F00S02VC_SHOULD_RELOAD_DATA"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldLoadData {
            getDailyAgentReport()
            self.shouldLoadData = false
        }
    }
    
    @objc func shouldReloadData() {
        shouldLoadData = true
    }
    
    func processData(_ data: DailyReport) {
        self.agentReportList = data
        if agentReportList.data.count == 1 {
            let vc = G03F00S03VC.init(withReport: agentReportList.data[0], ofDate: req.date)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.tbView.reloadData()
    }
    
    //MARK: - API
    func getDailyAgentReport() {
//        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        LoadingView.shared.showOverlay()
        serviceInstance.getDailyReport(req: req, success: { (report) in
            self.processData(report)
            LoadingView.shared.hideOverlayView(className: self.theClassName)
        }) { (error) in
            self.showAlert(message: error.message)
            LoadingView.shared.hideOverlayView(className: self.theClassName)
        }
    }

}


//MARK: - Extension
extension G03F00S02VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let report = agentReportList.data[indexPath.row]
        for item in report.getListData() {
            if item.id == DomainConst.ITEM_STATUS {
                if item.getStringData() == DomainConst.REPORT_STATUS_NOT_CREATED {
                    self.showAlert(message: "Báo cáo chưa được tạo bởi lễ tân")
                    return
                }
            }
        }
        let vc = G03F00S03VC.init(withReport: report, ofDate: req.date)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension G03F00S02VC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agentReportList.data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! G03F00S01TableViewCell
        cell.selectionStyle = .none
        cell.loadAgentReport(agentReportList.data[indexPath.row])
        return cell
    }
}











