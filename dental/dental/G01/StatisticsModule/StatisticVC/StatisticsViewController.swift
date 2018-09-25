//
//  StatisticsViewController.swift
//  dental
//
//  Created by Lâm Phạm on 7/31/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

enum QuickSelectItemType {
    case today
    case yesterday
    case thisMonth
    case lastMonth
    
}

class QuickSelectItem: NSObject {
    var type: QuickSelectItemType = .today
    
    init(type: QuickSelectItemType) {
        self.type = type
    }
    
    
    func getName() -> String {
        switch self.type {
        case .today:
            return "Hôm nay"
        case .yesterday:
            return "Hôm qua"
        case .thisMonth:
            return "Tháng này"
        case .lastMonth:
            return "Tháng trước"
        }
    }
}

class StatisticsViewController: BaseParentViewController {

    @IBOutlet weak var boxAgency: BorderSelectBox!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var heightQuickSelect: NSLayoutConstraint!
    @IBOutlet weak var cltvQuickSelect: UICollectionView!
    @IBOutlet weak var boxToDate: BorderSelectBox!
    @IBOutlet weak var boxFromDate: BorderSelectBox!
    
    let cellID = "QuickSelectCollectionViewCell"
    var listSelect: [QuickSelectItem] = []
    var selectedAgents: [ConfigBean] = []
    var canSelectAgent: Bool = false
    var isSelectingAgents:              Bool        = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigationBar(title: "Thống kê")
        btnSearch.drawRadius(6, color: .clear, thickness: 0)
        boxFromDate.set(placeholder: "Từ ngày", img: #imageLiteral(resourceName: "ic_calendar"), type: .datePicker)
        boxToDate.set(placeholder: "Đến ngày", img: #imageLiteral(resourceName: "ic_calendar"), type: .datePicker)
        boxAgency.set(placeholder: "Tất cả chỉ nhánh", img: #imageLiteral(resourceName: "ic_next"), type: .normal)
        boxAgency.delegate = self
        boxToDate.delegate = self
        boxFromDate.delegate = self
        cltvQuickSelect.delegate = self
        cltvQuickSelect.dataSource = self
        cltvQuickSelect.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        cltvQuickSelect.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        initItem()
        self.processRoleSelectAgent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isSelectingAgents {
            self.isSelectingAgents = false
            self.selectedAgents = BaseModel.shared.sharedArrayConfig
            if selectedAgents.count == 1 {
                boxAgency.setValue(selectedAgents[0].name)
            }
            if selectedAgents.count > 1 {
                boxAgency.setValue("Đã chọn \(selectedAgents.count) chi nhánh")
            }
            BaseModel.shared.sharedArrayConfig.removeAll()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }

    func initItem() {
        listSelect = [QuickSelectItem(type: .today), QuickSelectItem(type: .yesterday), QuickSelectItem(type: .thisMonth), QuickSelectItem(type: .lastMonth)]
        heightQuickSelect.constant = CGFloat(listSelect.count) * (30.0 + 4.0) + 30.0
    }
    
    func getWidthItem(withText text: String) -> CGFloat {
        var output:CGFloat = 0
        let font = UIFont.systemFont(ofSize: 14)
        let size = (text as NSString).size(attributes: [NSFontAttributeName: font])
        if text.count < 5 {
            if UIDevice.current.model == DeviceModel.iPhone5.rawValue {
                output = size.width + 32
            }
            else {
                output = size.width + 42
            }
        }
        else {
            if UIDevice.current.model == DeviceModel.iPhone5.rawValue {
                output = size.width + 52
            }
            else {
                output = size.width + 62
            }
        }
        return output
    }
    func processRoleSelectAgent() {
        let agentIDs = LoginBean.shared.user_agents_id.components(separatedBy: ",")
        selectedAgents.removeAll()
        if agentIDs.count > 1 {
            canSelectAgent = true
            boxAgency.alpha = 1
            for agent in LoginBean.shared.list_agent {
                if agent.id == "-1" {
                    selectedAgents.append(agent)
                    return
                }
            }
        } else {
            let id = LoginBean.shared.user_agents_id
            for agent in LoginBean.shared.list_agent {
                if id == agent.id {
                    selectedAgents.append(agent)
                }
            }
            canSelectAgent = false
            boxAgency.alpha = 0
        }
    }
    func processParam(byItem item: QuickSelectItem) -> GetStatisticsRequest {
        let param = GetStatisticsRequest()
        switch item.type {
        case .today:
            param.date_from = CommonProcess.getDateString(date: Date(), format: DomainConst.DATE_TIME_FORMAT_2)
            param.date_to = CommonProcess.getDateString(date: Date(), format: DomainConst.DATE_TIME_FORMAT_2)
            break
        case .yesterday:
            param.date_from = CommonProcess.getDateString(date: Date().adding(.day, value: -1), format: DomainConst.DATE_TIME_FORMAT_2)
            param.date_to = CommonProcess.getDateString(date: Date().adding(.day, value: -1), format: DomainConst.DATE_TIME_FORMAT_2)
            break
        case .thisMonth:
            let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date())))!
            param.date_from = CommonProcess.getDateString(date: startOfMonth, format: DomainConst.DATE_TIME_FORMAT_2)
            param.date_to = CommonProcess.getDateString(date: Date(), format: DomainConst.DATE_TIME_FORMAT_2)
            break
        case .lastMonth:
            let d = Date().adding(.month, value: -1)
            let startOfLastMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: d)))!
            let endOfLastMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfLastMonth)!
            param.date_from = CommonProcess.getDateString(date: startOfLastMonth, format: DomainConst.DATE_TIME_FORMAT_2)
            param.date_to = CommonProcess.getDateString(date: endOfLastMonth, format: DomainConst.DATE_TIME_FORMAT_2)
            break
        }
        if canSelectAgent {
            param.agent_id = param.getAgentID(listAgents: self.selectedAgents)
        } else {
            param.agent_id = "[\(LoginBean.shared.user_agents_id)]"
        }
        return param
    }
    
    //MARK: - Services
    func getRoleSelectAgent() {
        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        let param = GetStatisticsRequest()
        param.agent_id = "1"
        param.date_from = CommonProcess.getCurrentDate()
        param.date_to = CommonProcess.getCurrentDate()
        serviceInstance.getStatistics(req: param, success: { (resp) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.processRoleSelectAgent()
        }) { (error) in
            LoadingView.shared.hideOverlayView(className: self.theClassName)
            self.showAlert(message: error.message)
        }
    }
    
    //MARK: - IBAction
    @IBAction func btnSearchAction(_ sender: Any) {
        let param = GetStatisticsRequest()
        if let d = CommonProcess.getDate(fromString: boxFromDate.getValue(), withFormat: "dd/MM/yyyy") {
            param.date_from = CommonProcess.getDateString(date: d, format: DomainConst.DATE_TIME_FORMAT_2)
        }
        if let d = CommonProcess.getDate(fromString: boxToDate.getValue(), withFormat: "dd/MM/yyyy") {
            param.date_to = CommonProcess.getDateString(date: d, format: DomainConst.DATE_TIME_FORMAT_2)
        }
        param.agent_id = param.getAgentID(listAgents: selectedAgents)
        let vc = StatisticsDetailViewController(paramRequest: param)
        vc.selectedAgents = self.selectedAgents
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - Extension
extension StatisticsViewController: BorderSelectBoxDelegate {
    func borderSelectBoxDidTouch(box: BorderSelectBox) {
        if box == boxAgency {
            isSelectingAgents = true
            let view = MultiSelectionVC(nibName: MultiSelectionVC.theClassName, bundle: nil)
            view.createNavigationBar(title: DomainConst.CONTENT00446)
            view.setData(data: LoginBean.shared.list_agent,
                         selectedValue: "")
            view.setSelectedArray(value: selectedAgents)
            self.push(view, animated: true)
        }
    }
    func borderSelectBoxDidTouchDidFinishPickDate(box: BorderSelectBox) {
        if box == boxFromDate {
            
        }
        if box == boxToDate {
            
        }
    }
}

extension StatisticsViewController: ListAgencyViewControllerDelegate {
    func listAgencyViewControllerDidPick(listAgents: [ConfigBean]) {
        selectedAgents = listAgents
        if listAgents.count == 1 {
            boxAgency.setValue(listAgents[0].name)
        }
        if listAgents.count > 1 {
            boxAgency.setValue("Đã chọn \(listAgents.count) chi nhánh")
        }
    }
}

extension StatisticsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSelect.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! QuickSelectCollectionViewCell
        cell.loadText(listSelect[indexPath.row].getName())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StatisticsDetailViewController(paramRequest: self.processParam(byItem: listSelect[indexPath.row]))
        vc.selectedAgents = self.selectedAgents
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 100)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthItem: CGFloat = 0
        let word = listSelect[indexPath.row].getName()
        widthItem = getWidthItem(withText: word)
        return CGSize(width: widthItem, height: 30)
    }
}















