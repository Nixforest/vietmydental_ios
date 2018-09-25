//
//  StatisticsDetailViewController.swift
//  dental
//
//  Created by Lâm Phạm on 8/1/18.
//  Copyright © 2018 SPJ. All rights reserved.
//
//  P0031_GetStatistic_API

import UIKit
import harpyframework

class StatisticsDetailViewController: ChildExtViewController {

    @IBOutlet weak var detailView: StatisticsDetailView!
    
    let cellID = "QuickSelectCollectionViewCell"
    var selectedAgents: [ConfigBean] = []
    var param: GetStatisticsRequest!
    
    init(paramRequest: GetStatisticsRequest) {
        super.init(nibName: "StatisticsDetailViewController", bundle: Bundle.main)
        self.param = paramRequest
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Thống kê")
        detailView.delegate = self
        detailView.param = self.param
        detailView.loadSelectedAgents(agents: self.selectedAgents)
        self.getStatistics(param: self.param)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Services
    func getStatistics(param: GetStatisticsRequest) {
        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        serviceInstance.getStatistics(req: param, success: { (resp) in
            self.detailView.loadUI(statistic: resp)
            LoadingView.shared.hideOverlayView(className: self.theClassName)
        }) { (error) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.showAlert(message: error.message)
        }
    }

}

extension StatisticsDetailViewController: StatisticsDetailViewDelegate {
    func statisticsDetailViewDidSelectCollected() {
        let receiptParam = GetListReceiptRequest()
        receiptParam.date_from = param.date_from
        receiptParam.date_to = param.date_to
        receiptParam.agent_id = param.agent_id
        receiptParam.status = LoginBean.shared.getReceiptStatusCollected().id
        let vc = StatisticsListViewController(withParam: receiptParam)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func statisticsDetailViewDidSelectNotCollected() {
        let receiptParam = GetListReceiptRequest()
        receiptParam.date_from = param.date_from
        receiptParam.date_to = param.date_to
        receiptParam.agent_id = param.agent_id
        receiptParam.status = LoginBean.shared.getReceiptStatusNotCollected().id
        let vc = StatisticsListViewController(withParam: receiptParam)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}














