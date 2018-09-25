//
//  SelectionVC.swift
//  dental
//
//  Created by SPJ on 2/17/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class SelectionVC: G00AddressSelectVC {
    // MARK: Properties
    /** Selected array */
    var _selectedArray:         [ConfigBean] = [ConfigBean]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /**
     * Set selected array
     * - parameter value: Value of array
     */
    public func setSelectedArray(value: [ConfigBean]) {
        self._selectedArray = value
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
}
