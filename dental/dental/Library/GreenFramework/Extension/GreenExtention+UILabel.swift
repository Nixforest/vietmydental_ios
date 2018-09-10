//
//  GreenExtention+UILabel.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import UIKit
public extension UILabel
{
    public func setStyle(_ style : TextStyle)
    {
        self.font = greenDefine.getFontStyle(style).font
        self.textColor = greenDefine.getFontStyle(style).color
    }
    
    public func setBold()
    {
        self.font = UIFont(name: greenDefine.GreenFontBold.fontName, size: self.font.pointSize)
    }

}


class UILabelGeneral : UILabel
{
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()

    }
    
    func style()
    {
        self.textColor = greenDefine.GreenGeneralTextColor
    }
}

class UILabelSub : UILabel
{
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()
        
    }
    
    func style()
    {
        self.textColor = greenDefine.GreenGeneralTextColor
    }
}

class UILabelHighlight : UILabel
{
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()
        
    }
    
    func style()
    {
        self.textColor = greenDefine.GreenGeneralTextColor
    }
}
