//
//  G01F03S02VC.swift
//  dental
//
//  Created by SPJ on 2/20/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F03S02VC: SelectionVC {
    // MARK: Properties
    /** Data */
    var _dataExt:               [ConfigExtBean] = [ConfigExtBean]()
    /** Original data */
    var _originDataExt:         [ConfigExtBean] = [ConfigExtBean]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setDataExt(data: ListConfigBean, selectedValue: String) {
        for item in data.getData() {
            self._dataExt.append(item)
            if !item._dataExt.isEmpty {
                for child in item._dataExt {
                    self._dataExt.append(child)
                }
            }
        }
        self._selectedValue = selectedValue
        self._originDataExt = self._dataExt
        tblInfo.reloadData()
    }
    
    /**
     * Tells the data source to return the number of rows in a given section of a table view.
     * - returns: List information count
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataExt.count
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self._dataExt[indexPath.row]
        if !data._dataExt.isEmpty {
            // Group
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = data.name
            cell.textLabel?.font = GlobalConst.BASE_BOLD_FONT
            return cell
        } else {
            // Item
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.textLabel?.text = "- " + data.name
            cell.textLabel?.font = GlobalConst.BASE_FONT
            if data.id == _selectedValue {
                cell.textLabel?.textColor = UIColor.red
            } else {
                cell.textLabel?.textColor = UIColor.black
            }
            cell.detailTextLabel?.text = data._dataStr
            cell.detailTextLabel?.font = GlobalConst.BASE_FONT
            return cell
        }
    }
    /**
     * Tells the delegate that the specified row is now selected.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self._dataExt[indexPath.row]
        if data._dataExt.isEmpty {
            BaseModel.shared.sharedString = _dataExt[indexPath.row].id
            self.backButtonTapped(self)
        }
    }

    override func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let keyword = searchText.removeSign().lowercased()
            _dataExt = _originDataExt.filter { $0.name.removeSign().lowercased()
                .contains(keyword) }
        } else {
            _dataExt = _originDataExt
        }
        self.tblInfo.reloadData()
    }
}
