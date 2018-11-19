//
//  G04F00S02VC.swift
//  dental
//
//  Created by Lâm Phạm on 11/10/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G04F00S02VC: ChildExtViewController {
    
    @IBOutlet weak var tbView: UITableView!
    
    var listCustomer = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Lịch sử quét")
        tbView.delegate = self
        tbView.dataSource = self
        self.perform(#selector(getData))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func getData() {
        listCustomer = app.getListCustomer()
        for customer in listCustomer {
            if customer.keys.count != 3 {
                listCustomer.remove(at: listCustomer.index(of: customer)!)
            }
        }
        tbView.reloadData()
    }
    

}

extension G04F00S02VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = listCustomer[indexPath.row]
        let vc = G01F00S02VC(nibName: G01F00S02VC.theClassName, bundle: nil)
        vc.setId(id: customer["id"]!, code: customer["code"]!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension G04F00S02VC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCustomer.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customer = listCustomer[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = customer["name"]!
        cell.textLabel?.font = GlobalConst.BASE_FONT
        cell.detailTextLabel?.text = customer["code"]!
        cell.detailTextLabel?.font = GlobalConst.BASE_FONT
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}






















