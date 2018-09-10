//
//  G01F03S06VC.swift
//  dental
//
//  Created by Pham Trung Nguyen on 5/13/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework
import AlamofireImage
import Alamofire

class G01F03S06VC: G01F03S02VC {
    /** List material images */
    var _listImg:  [UIImage]               = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadImageFromServer()
    }
    
    /**
     * Load image from server
     */
    internal func loadImageFromServer() {
        _listImg.removeAll()
        for item in self._dataExt {
            Alamofire.request(
                item.name).responseImage(
                    completionHandler: { response in
                        if let img = response.result.value {
                            self._listImg.append(img)
                            self.tblInfo.reloadData()
                        }
                })
        }
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
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        if indexPath.row < self._dataExt.count {
            let data = self._dataExt[indexPath.row]
            cell.imageView?.getImgFromUrl(link: data.name, contentMode: .scaleAspectFill)
            if _listImg.count > indexPath.row {
                cell.imageView?.image = _listImg[indexPath.row]
            }
        }
        return cell
    }
}
