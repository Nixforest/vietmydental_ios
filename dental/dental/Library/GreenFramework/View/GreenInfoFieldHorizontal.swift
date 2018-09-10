//
//  InfoFieldHorizontal.swift
//  Green
//
//  Created by KieuVan on 2/16/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit

open class GreenInfoFieldHorizontal: GreenView {

    @IBOutlet weak var widthRatio: NSLayoutConstraint!
    @IBOutlet weak var leftView: GCleanView!
    @IBOutlet weak var rightView: GCleanView!
    
    @IBOutlet weak var tvRight: GreenTextView!
    @IBOutlet weak var tvLeft: GreenTextView!
    
    open var title : String
        {
        set{
            tvLeft.text = newValue
        }
        get{
            return tvLeft.text
        }
    }
    
    open var content : String
        {
        set{
            tvRight.text = newValue
        }
        get{
            return tvRight.text
        }
    }


    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override open func initStyle()
    {
        super.initStyle()
        tvRight.textContainer.lineFragmentPadding = 0;
        tvRight.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tvLeft.textContainer.lineFragmentPadding = 0;
        tvLeft.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tvRight.contentOffset = CGPoint.init(x: 0, y: 0)
        tvRight.layer.cornerRadius = CGFloat(greenDefine.GreenRadius)
        tvLeft.isEditable = false;
        tvRight.isEditable = false;
        
        setTextStyle(greenDefine.GreenInfoFieldHorizontal_LeftTextStyle, right: greenDefine.GreenInfoFieldHorizontal_RightTextStyle)
    }
    
    open  func setTextStyle(_ left : TextStyle, right : TextStyle)
    {
        tvLeft.setStyle(left)
        tvRight.setStyle(right)
    }
    open  func setColor(_ left : UIColor, right : UIColor)
    {
        tvLeft.textColor = left
        tvRight.textColor = right;
    }
    
    open func setPadding(_ insets : UIEdgeInsets)
    {
        tvLeft.textContainerInset = insets;
        tvRight.textContainerInset = insets;
    }
    
    open func setWidthRatio(radio : Float)
    {
        widthRatio.constant = CGFloat(radio);
    }
    
}
