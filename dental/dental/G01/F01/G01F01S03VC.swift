//
//  G01F01S03VC.swift
//  dental
//
//  Created by Pham Trung Nguyen on 5/8/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F01S03VC: SelectionVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /**
     * Request create new pathological
     * - parameter name: Name of pathological
     */
    internal func requestCreateNewPathological(name: String) {
        PathologicalCreateRequest.request(
            view: self,
            name: name, description: name,
            completionHandler: finishRequest)
    }
    
    /**
     * Handle finish request
     */
    override func finishRequest(_ model: Any?) {
        let data = model as! String
        let model = PathologicalCreateResp(jsonString: data)
        if model.isSuccess() {
            // Do when create success
            showAlert(message: model.message, okHandler: {
                alert in
                LoginBean.shared.addPathological(bean: model.data)
                BaseModel.shared.sharedString = model.data.id
                self.backButtonTapped(self)
            })
        } else {
            showAlert(message: model.message)
        }
    }
    
    /**
     * Asks the data source to return the number of sections in the table view.
     * - returns: 1 section
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /**
     * Tells the data source to return the number of rows in a given section of a table view.
     * - returns: List information count
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return _data.count
        case 1:
            return 1
        default:
            break
        }
        return 0
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            if indexPath.row < self._data.count {
                let data = self._data[indexPath.row]
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                if !_selectedArray.isEmpty {
                    for item in _selectedArray {
                        if data.id == item.id {
                            cell.accessoryType = .checkmark
                            break
                        } else {
                            cell.accessoryType = .none
                        }
                    }
                } else {
                    if data.id == _selectedValue {
                        cell.textLabel?.textColor = UIColor.red
                    } else {
                        cell.textLabel?.textColor = UIColor.black
                    }
                }
            }
            return cell
        case 1:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = DomainConst.CONTENT00065
            cell.textLabel?.font = GlobalConst.BASE_BOLD_FONT
            cell.imageView?.image = ImageManager.getImage(
                named: DomainConst.VMD_ADD1_ICON_IMG_NAME, margin: GlobalConst.MARGIN * 2)
            cell.imageView?.contentMode = .scaleAspectFit
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    /**
     * Tells the delegate that the specified row is now selected.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            BaseModel.shared.sharedString = _data[indexPath.row].id
            self.backButtonTapped(self)
            break
        case 1:
            if let searchText = _searchController.searchBar.text, !searchText.isEmpty {
                showAlert(message: "Bạn có chắc chắn muốn tạo mới Bệnh lý \"\(searchText)\" không?", okHandler: { alert in
                    self.requestCreateNewPathological(name: searchText)
                }, cancelHandler: { alert in
                    // Do nothing
                })
            }
            
            break
        default:
            break
        }
        
    }
}
