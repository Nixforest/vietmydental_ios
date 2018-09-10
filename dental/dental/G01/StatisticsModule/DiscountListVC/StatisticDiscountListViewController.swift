//
//  StatisticDiscountListViewController.swift
//  dental
//
//  Created by Lâm Phạm on 8/9/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class StatisticDiscountListViewController: ChildExtViewController {

    @IBOutlet weak var tbView: UITableView!
    
    let cellID = "DiscountListTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Danh sách giảm giá")
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UINib(nibName: cellID, bundle: Bundle.main), forCellReuseIdentifier: cellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension StatisticDiscountListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DiscountListTableViewCell
        cell.selectionStyle = .none
        return cell
    }
}






















