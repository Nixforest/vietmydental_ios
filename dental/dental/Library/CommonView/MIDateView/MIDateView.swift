//
//  MIDateView.swift
//  ReBook
//
//  Created by Lê Dũng on 9/15/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit

enum PickerType {
    case justDate
    case dateAndTime
}


protocol MIDateViewDelegate: class {
    func dateViewDidFinishPick(dateView: MIDateView)
}

class MIDateView: BaseView {

//    @IBOutlet weak var hourPicker: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btSelect: UIButton!
    @IBOutlet weak var dateView: UIView!
    
    weak var delegate : MIDateViewDelegate!
    
    override func firstInit() {
        datePicker.calendar = Calendar(identifier: .gregorian)
        dateView.backgroundColor = UIColor.white
        backgroundColor = UIColor.white
        dateView.layer.masksToBounds = false;
        dateView.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        dateView.layer.shadowRadius = 4;
        dateView.layer.shadowOpacity = 0.12;
        dateView.layer.shadowColor = UIColor.black.cgColor
    }
    
    deinit {
    }
    
    var date: Date {
        set {
            datePicker.date = newValue
        }
        get {
            return datePicker.date
        }
    }
    init(type: PickerType) {
        super.init(frame: CGRect.init())
        switch type {
        case .justDate:
            datePicker.datePickerMode = .date
        case .dateAndTime:
            datePicker.datePickerMode = .dateAndTime
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func selected(_ sender: Any) {
        delegate.dateViewDidFinishPick(dateView: self)
    }

}
