//
//  MultiSelectionVC.swift
//  dental
//
//  Created by Pham Trung Nguyen on 9/20/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

@objc protocol MultiSelectionVCDelegate: class {
    @objc optional func multiSelectionVCDidSelect(list: [ConfigBean])
}

class MultiSelectionVC: SelectionVC {
    
    var delegate: MultiSelectionVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParentViewController {
            BaseModel.shared.sharedArrayConfig = getSelectedAgents()
            delegate.multiSelectionVCDidSelect!(list: getSelectedAgents())
        }
    }
    
    //++BUG0086_1
    private func getSelectedAgents() -> [ConfigBean] {
        var list = [ConfigBean]()
        for agent in self._data {
            if agent.isSelected {
                list.append(agent)
            }
        }
        return list
    }
    //--BUG0086_1

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    /**
     * Tells the delegate that the specified row is now selected.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            _data[0].isSelected = true
            for i in 1..._data.count - 1 {
                _data[i].isSelected = false
            }
        } else {
            _data[0].isSelected = false
            let currentSelect = _data[indexPath.row]
            currentSelect.isSelected = !currentSelect.isSelected
        }
//        for i in 0..<_selectedArray.count {
//            if currentSelect.id == _selectedArray[i].id {
//                // Deselect -> remove from selected array
//                _selectedArray.remove(at: i)
//                BaseModel.shared.sharedArrayConfig = _selectedArray
//                tableView.reloadData()
//                return
//            }
//        }
//        // Add new
//        _selectedArray.append(_data[indexPath.row])
//        BaseModel.shared.sharedArrayConfig = _selectedArray
        tableView.reloadData()
    }
}
