//
//  NavigationView.swift
//  MiBook
//
//  Created by Lê Dũng on 7/10/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit



enum NavigationStyle : String
{
    case menu = "GMenu"
    case back = "GBack"
    case custom = ""
}


class NavigationView: GreenView {
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftBt: GreenButtonCenter!
    
    @IBOutlet weak var lbTitle: UILabel!
    var completion : (()->Void)!

    override func initStyle()
    {
        lbTitle.textColor = template.titleTextColor
        statusView.backgroundColor = template.mainAColor
        contentView.backgroundColor = template.mainAColor
    }
    func setTitle(title: String, color: UIColor) {
        lbTitle.text = title
        lbTitle.textColor = color
    }
    func setBackgndColor(color: UIColor) {
        statusView.backgroundColor = color
        contentView.backgroundColor = color
    }
    func set(style : NavigationStyle, title : String, completion : @escaping (()->Void))
    {
        self.completion = completion
        var image  : UIImage!
        weak var weakself = self
        switch style
        {
            case .menu : image = "GMenu".image();   break;
            case .back :image = "GBack".image();   break;
            case .custom :image = "GMenu".image();   break;
        }
        leftBt.setTarget(image.tint("59657f".hexColor())) { (button) in
            weakself?.completion()
        }
        lbTitle.text = title;
    }

}
