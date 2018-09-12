//
//  StatisticsListViewController.swift
//  dental
//
//  Created by Lâm Phạm on 8/16/18.
//  Copyright © 2018 SPJ. All rights reserved.
//
//  P0032_GetListReceipts_API


import UIKit
import harpyframework

enum ReceiptStatusType {
    case collected
    case notCollected
}

class StatisticsListViewController: ChildExtViewController {

    @IBOutlet weak var headerView: StatisticsListHeaderView!
    @IBOutlet weak var tbView: UITableView!
    
    let cellID = "StatisticsListTableViewCell"
    
    var type: ReceiptStatusType = .collected
    var collectedRawVal = ""
    var notCollectedRawVal = ""
    var pageIndex = 1
    var canLoadMore: Bool = false
    var param: GetListReceiptRequest!
    var receipt: MedicalReceipt!
    
    /** init controller with GetListReceiptRequest */
    init(withParam: GetListReceiptRequest) {
        super.init(nibName: "StatisticsListViewController", bundle: Bundle.main)
        self.param = withParam
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processNavigationBar(statusCode: self.param.status)
        self.getListReceipt()
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UINib(nibName: cellID, bundle: Bundle.main), forCellReuseIdentifier: cellID)
        headerView.dropShadow(color: UIColor.black, radius: 3, opacity: 0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Logic
    
    /** Setting Navigation Bar title */
    private func processNavigationBar(statusCode: String) {
        switch statusCode {
        case DomainConst.RECEIPT_STATUS_COLLECTED:
            self.createNavigationBar(title: "Danh sách đã thu")
            collectedRawVal = getStatusRawValue(byStatus: DomainConst.RECEIPT_STATUS_COLLECTED)
            self.type = .collected
        case DomainConst.RECEIPT_STATUS_NOT_COLLECTED:
            self.createNavigationBar(title: "Danh sách chưa thu")
            notCollectedRawVal = getStatusRawValue(byStatus: DomainConst.RECEIPT_STATUS_NOT_COLLECTED)
            self.type = .notCollected
        default:
            self.createNavigationBar(title: "Lỗi trạng thái")
        }
    }
    private func getStatusRawValue(byStatus status: String) -> String {
        for item in LoginBean.shared.status_receipt {
            if item.id == status {
                return item.id
            }
            break
        }
        return ""
    }
    private func processResponse(resp: MedicalReceipt) {
        if resp.data.count() == LoginBean.shared.app_page_size.intValue() {
            shouldLoadMore(should: true)
        } else {
            shouldLoadMore(should:  false)
        }
        if self.receipt == nil {
            receipt = resp
        } else {
            var data = self.receipt.data.getData()
            data.append(contentsOf: resp.data.getData())
            self.receipt.data.setData(data: data)
        }
        if resp.data.count() > 0 {
            resp.data.getData()[0].isSelected = true
            self.headerView.loadReceipt(resp.data.getData()[0])
        }
        self.tbView.reloadData()
    }
    func shouldLoadMore(should: Bool) {
        if should {
            pageIndex += 1
            canLoadMore = true
        } else {
            canLoadMore = false
        }
    }
    
    //MARK: - Services
    func getListReceipt() {
        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        param.page = "\(pageIndex)"
        serviceInstance.getListReceipt(req: self.param, success: { (resp) in
            self.processResponse(resp: resp)
            LoadingView.shared.hideOverlayView(className: self.theClassName)
        }) { (error) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.showAlert(message: error.message)
        }
    }

}

extension StatisticsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if receipt == nil {
            return 0
        }
        return receipt.data.count()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! StatisticsListTableViewCell
        cell.selectionStyle = .none
        cell.loadReceipt(receipt.data.getData()[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for item in receipt.data.getData() {
            item.isSelected = false
        }
        receipt.data.getData()[indexPath.row].isSelected = true
        tbView.reloadData()
        headerView.loadReceipt(receipt.data.getData()[indexPath.row])
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.receipt.data.getData().count - 1 {
            if canLoadMore {
                self.getListReceipt()
            }
        }
    }
}


