//
//  G05F01S01VC.swift
//  dental
//
//  Created by Lâm Phạm on 11/18/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G05F01S01VC: ChildExtViewController {

    @IBOutlet weak var btnBooking: UIButton!
    @IBOutlet weak var tfNote: UITextView!
    @IBOutlet weak var boxPhone: BorderSelectBox!
    @IBOutlet weak var boxDate: BorderSelectBox!
    @IBOutlet weak var boxName: BorderSelectBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Đặt lịch hẹn")
        self.perform(#selector(drawUI), with: nil, afterDelay: 0.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func drawUI() {
        boxPhone.set(placeholder: "", img: #imageLiteral(resourceName: "ic_phone_pad"), type: .phone)
        boxPhone.setValue(BaseModel.shared.sharedString)
        boxPhone.isUserInteractionEnabled = false
        BaseModel.shared.sharedString = ""
        boxName.set(placeholder: "Họ tên", img: #imageLiteral(resourceName: "ic_compose"), type: .normal)
        let strDate = CommonProcess.getDateString(date: Date())
        boxDate.set(placeholder: strDate, img: #imageLiteral(resourceName: "ic_calendar"), type: .datePicker)
        tfNote.drawRadius(6, color: UIColor.lightGray, thickness: 0.5)
        btnBooking.drawRadius(6)
        boxPhone.delegate = self
        boxName.delegate = self
        boxDate.delegate = self
    }
    
    
    @IBAction func btnBookingAction(_ sender: Any) {
    }
    
}

extension G05F01S01VC: BorderSelectBoxDelegate {
    func borderSelectBoxDidTouch(box: BorderSelectBox) {
        
    }
    func borderSelectBoxDidTouchDidFinishPickDate(box: BorderSelectBox) {
        
    }
}






