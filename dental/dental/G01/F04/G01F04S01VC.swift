//
//  G01F04S01VC.swift
//  dental
//
//  Created by SPJ on 2/21/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F04S01VC: ChildExtViewController {
    // MARK: Properties
    /** Data */
    var _data:          ListConfigBean = ListConfigBean()
    /** Information table view */
    var _tblInfo:           UITableView             = UITableView()
    
    // MARK: Static values
    // MARK: Constant    
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createInfoTableView()
        self.view.addSubview(_tblInfo)
    }
    
    /**
     * Set data
     * - parameter bean: Data to set
     */
    public func setData(bean: [ConfigExtBean]) {
        self._data.setData(data: bean)
    }
    
    /**
     * Check if current item is in completed status
     * - returns: True if value of status item is Completed, False otherwise
     */
    internal func isCompleted() -> Bool {
        return (self._data.getData(id: DomainConst.ITEM_STATUS)._dataStr
            == DomainConst.TREATMENT_SCHEDULE_PROCESS_COMPLETED)
    }
    
    /**
     * Check if current treatment schedule can update data
     * - returns: True if value of can_update item is 1, False otherwise
     */
    internal func canUpdate() -> Bool {
        return self._data.getData(id: DomainConst.ITEM_CAN_UPDATE)._dataStr.isON()
    }
    
    internal func requestUpdate(isShowLoading: Bool = true) {
        TreatmentScheduleProcessUpdateRequest.request(
            action: #selector(finishUpdate(_:)),
            view: self,
            id: self._data.getData(id: DomainConst.ITEM_ID)._dataStr,
            teeth_id: self._data.getData(id: DomainConst.ITEM_TEETH_ID)._dataStr,
            name: self._data.getData(id: DomainConst.ITEM_NAME)._dataStr,
            content: self._data.getData(id: DomainConst.ITEM_DESCRIPTION)._dataStr,
            note: self._data.getData(id: DomainConst.ITEM_NOTE)._dataStr,
            status: self._data.getData(id: DomainConst.ITEM_STATUS)._dataStr,
            isShowLoading: isShowLoading)
    }
    
    internal func finishUpdate(_ notification: Notification) {
        let data = notification.object as! String
        let model = TreatmentInfoRespBean(jsonString: data)
        if model.isSuccess() {
            self.setData(bean: model.data.getData())
            _tblInfo.reloadData()
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
    }
}

// MARK: Protocol - UITableViewDataSource
extension G01F04S01VC: UITableViewDataSource {
    /**
     * Asks the data source to return the number of sections in the table view.
     * - returns: 1 section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /**
     * Tells the data source to return the number of rows in a given section of a table view.
     * - returns: List information count
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self._data.count()
        } else {
            return self._data.getData(id: DomainConst.ITEM_DETAILS)._dataExt.count
        }
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row > self._data.count() {
                return UITableViewCell()
            }
            let data = self._data.getData()[indexPath.row]
            var imagePath = DomainConst.INFORMATION_IMG_NAME
            if let img = DomainConst.VMD_IMG_LIST[data.id] {
                imagePath = img
            }
            let image = ImageManager.getImage(named: imagePath,
                                              margin: GlobalConst.MARGIN * 2)
            switch data.id {
            case DomainConst.ITEM_DETAILS:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_BOLD_FONT
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            case DomainConst.ITEM_CAN_UPDATE, DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_TEETH_ID,
                 DomainConst.ITEM_ID:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.contentView.isHidden = true
                return cell
            default:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.text = data._dataStr
                cell.detailTextLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.lineBreakMode = .byWordWrapping
                cell.detailTextLabel?.numberOfLines = 0
                if data._dataStr.isEmpty && self.canUpdate() {
                    cell.detailTextLabel?.text = LoginBean.shared.getUpdateText()
                    cell.detailTextLabel?.textColor = UIColor.red
                }
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            }
        case 1:     // Section Medicine
            let data = self._data.getData(id: DomainConst.ITEM_DETAILS)._dataExt[indexPath.row]
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.textLabel?.text = "- " + data.name
            cell.textLabel?.font = GlobalConst.BASE_FONT
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            break
        }
        
        return UITableViewCell()        
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F04S01VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row > self._data.count() {
                return
            }
            let data = self._data.getData()[indexPath.row]
            switch data.id {
            case DomainConst.ITEM_DIAGNOSIS:
                if self.canUpdate() {
                    
                }
            case DomainConst.ITEM_TEETH:
                if self.canUpdate() {
                    
                }
            case DomainConst.ITEM_TREATMENT:
                if self.canUpdate() {
                    
                }
            default:
                break
            }
            break
            //        case 1:
            //            let data = getData(id: DomainConst.ITEM_DETAILS)._dataExt[indexPath.row]
            //            self.openTreatmentScheduleDetail(bean: data)
        //            break
        default:
            break
        }
        
    }
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch self._data.getData()[indexPath.row].id {
            case DomainConst.ITEM_CAN_UPDATE, DomainConst.ITEM_STATUS,
                 DomainConst.ITEM_TEETH_ID,
                 DomainConst.ITEM_ID:
                return 0
            default:
                return UITableViewAutomaticDimension
            }
        default:
            return UITableViewAutomaticDimension
        }
        
    }
}
