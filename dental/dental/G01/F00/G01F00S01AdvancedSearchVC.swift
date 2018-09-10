//
//  G01F00S01AdvancedSearchVC.swift
//  dental
//
//  Created by Lâm Phạm on 8/8/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F00S01AdvancedSearchVC: ChildExtViewController {

    @IBOutlet weak var boxToDate: BorderSelectBox!
    @IBOutlet weak var boxFromDate: BorderSelectBox!
    @IBOutlet weak var boxPhone: BorderSelectBox!
    @IBOutlet weak var boxName: BorderSelectBox!
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Tìm kiếm")
        btnSearch.drawRadius(6)
        boxName.set(placeholder: "Tìm theo họ tên", img: #imageLiteral(resourceName: "ic_compose"), type: .compose)
        boxName.delegate = self
        boxPhone.set(placeholder: "Tìm theo số điện thoại", img: #imageLiteral(resourceName: "ic_phone_pad"), type: .phone)
        boxPhone.delegate = self
        boxFromDate.set(placeholder: "Từ ngày", img: #imageLiteral(resourceName: "ic_calendar"), type: .datePicker)
        boxFromDate.delegate = self
        boxToDate.set(placeholder: "Đến ngày", img: #imageLiteral(resourceName: "ic_calendar"), type: .datePicker)
        boxToDate.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension G01F00S01AdvancedSearchVC: BorderSelectBoxDelegate {
    func borderSelectBoxDidTouch(box: BorderSelectBox) {
        
    }
    func borderSelectBoxDidTouchDidFinishPickDate(box: BorderSelectBox) {
        if box == boxFromDate {
            
        }
        if box == boxToDate {
            
        }
    }
}












