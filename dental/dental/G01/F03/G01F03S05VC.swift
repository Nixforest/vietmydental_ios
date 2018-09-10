//
//  G01F03S05VC.swift
//  dental
//
//  Created by Pham Trung Nguyen on 5/8/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F03S05VC: SelectionVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
        let currentSelect = _data[indexPath.row]
        for i in 0..<_selectedArray.count {
            if currentSelect.id == _selectedArray[i].id {
                // Deselect -> remove from selected array
                _selectedArray.remove(at: i)
                BaseModel.shared.sharedArrayConfig = _selectedArray
                tableView.reloadData()
                return
            }
        }
        // Add new
        _selectedArray.append(_data[indexPath.row])
        BaseModel.shared.sharedArrayConfig = _selectedArray
        tableView.reloadData()
        
    }
}
