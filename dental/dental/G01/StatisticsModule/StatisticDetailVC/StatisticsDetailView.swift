//
//  StatisticsDetailView.swift
//  dental
//
//  Created by Lâm Phạm on 9/3/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

@objc protocol StatisticsDetailViewDelegate: class {
    @objc optional func statisticsDetailViewDidSelectListDept()
    @objc optional func statisticsDetailViewDidSelectListDiscount()
    @objc optional func statisticsDetailViewDidSelectCollected()
    @objc optional func statisticsDetailViewDidSelectNotCollected()
}

class StatisticsDetailView: BaseView {
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbDebt: UILabel!
    @IBOutlet weak var btnListDebt: UIButton!
    @IBOutlet weak var btnListDiscount: UIButton!
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var lbFinal: UILabel!
    @IBOutlet weak var lbDiscount: UILabel!
    @IBOutlet weak var lbCustomerCount: UILabel!
    @IBOutlet weak var cltvAgents: UICollectionView!
    
    var delegate: StatisticsDetailViewDelegate!
    
    let cellID = "QuickSelectCollectionViewCell"
    var selectedAgents: [ConfigBean] = []
    var param: GetStatisticsRequest!
    
    override func firstInit() {
        self.backgroundColor = UIColor.white
        cltvAgents.delegate = self
        cltvAgents.dataSource = self
        cltvAgents.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        cltvAgents.reloadData()
    }
    
    //MARK: - Logic
    /**
     *  show selected agent UI
     */
    func loadSelectedAgents(agents: [ConfigBean]) {
        self.selectedAgents = agents
        processListAgent()
    }
    /**
     *  process selected agent
     */
    func processListAgent() {
        if selectedAgents.count == 0 {
            let listAgent = LoginBean.shared.list_agent
            for agent in listAgent {
                if agent.id == "-1" {
                    selectedAgents.append(agent)
                }
            }
        }
        cltvAgents.reloadData()
    }
    
    /**
     *  get parameters for today statistics request
     */
    func getParamToday() -> GetStatisticsRequest {
        let param = GetStatisticsRequest()
        param.agent_id = "[\(LoginBean.shared.user_agents_id)]"
        param.date_from = CommonProcess.getDateString(date: Date(), format: "yyyy/MM/dd")
        param.date_to = CommonProcess.getDateString(date: Date(), format: "yyyy/MM/dd")
        return param
    }
    
    /**
     *  get width item of collection view
     *  param: text need calculating
     */
    func getWidthItem(withText text: String) -> CGFloat {
        var output:CGFloat = 0
        let font = UIFont.systemFont(ofSize: 14)
        let size = (text as NSString).size(attributes: [NSFontAttributeName: font])
        if text.count < 10 {
            output = size.width + 17
        }
        else {
            if UIDevice.current.model == DeviceModel.iPhone5.rawValue {
                output = size.width + 7
            }
            else {
                output = size.width + 7
            }
        }
        return output
    }
    
    /**
     *  load UI based on response from server
     */
    func loadUI(statistic: StatisticsModel) {
        if let dateFrom = CommonProcess.getDate(fromString: param.date_from, withFormat: DomainConst.DATE_TIME_FORMAT_2),
            let dateTo = CommonProcess.getDate(fromString: param.date_to, withFormat: DomainConst.DATE_TIME_FORMAT_2) {
            let strFrom = CommonProcess.getDateString(date: dateFrom, format: DomainConst.DATE_TIME_FORMAT_1)
            let strTo = CommonProcess.getDateString(date: dateTo, format: DomainConst.DATE_TIME_FORMAT_1)
            lbTime.text = "Từ \(strFrom) đến \(strTo)"
        }
//        if statistic.total.replacingOccurrences(of: ",", with: "").intValue() == 0 {
//            btnListDebt.alpha = 0
//            btnListDiscount.alpha = 0
//        } else {
//            btnListDebt.alpha = 1
//            btnListDiscount.alpha = 1
//        }
        lbTotal.text = "\(statistic.total)"
        lbDebt.text = "\(statistic.debt)"
        lbCustomerCount.text = "\(statistic.customerCount)"
        lbFinal.text = "\(statistic.final)"
        lbDiscount.text = "\(statistic.discount)"
        processListAgent()
    }
    
    //MARK: - Services
//    func getStatistics(param: GetStatisticsRequest) {
//        self.param = param
//        serviceInstance.getStatistics(req: param, success: { (resp) in
//            self.loadUI(statistic: resp)
//        }) { (error) in
//
//        }
//    }
    
    //MARK: - IBAction
    // select list collected customers
    @IBAction func btnListCollectedAction(_ sender: Any) {
        delegate.statisticsDetailViewDidSelectCollected!()
    }
    // select list not collected customers
    @IBAction func btnListNotCollectedAction(_ sender: Any) {
        delegate.statisticsDetailViewDidSelectNotCollected!()
    }
    
}


extension StatisticsDetailView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAgents.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! QuickSelectCollectionViewCell
        cell.viewBorder.drawRadius(10)
        cell.loadText(selectedAgents[indexPath.row].name)
        if #available(iOS 8.2, *) {
            cell.lb.font = UIFont.systemFont(ofSize: 11, weight: UIFontWeightLight)
        } else {
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthItem: CGFloat = 0
        let word = selectedAgents[indexPath.row].name
        widthItem = getWidthItem(withText: word)
        return CGSize(width: widthItem, height: 20)
    }
}
