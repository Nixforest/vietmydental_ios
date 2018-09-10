//
//  GreenStepField.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/29/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit

class GreenStepField: GreenView {

    @IBOutlet weak var tfContent: UITextField!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var rightView: GreenButtonCenter!
    @IBOutlet weak var leftView: GreenButtonCenter!
    var actionHandle : ((Double) -> Void)!

    var min = 0.0
    var max = 0.0
    var step = 0.0
    
     private func validate()
    {
        if(value > max )
        {
            value = max;
        }
        if(value < min)
        {
            value = min
        }
        tfContent.text = String(value)
    }

    override func initStyle()
    {
        self.layer.cornerRadius = greenDefine.GreenInfoFieldStep_Radius
        self.clipsToBounds = true;
        self.view.backgroundColor = greenDefine.GreenInfoFieldStep_BackgroundColor
        self.backgroundColor = greenDefine.GreenInfoFieldStep_BackgroundColor
        tfContent.textColor = greenDefine.GreenInfoFieldStep_TextColor
        weak var weakSelf : GreenStepField!  = self
        
        
        leftView.setTarget(greenDefine.GreenInfoFieldStep_LeftImage.tint(greenDefine.GreenInfoFieldStep_ButtonTintColor)) { (button) in
            weakSelf.value = weakSelf.value - weakSelf.step;
            
            if(weakSelf.actionHandle != nil)
            {
                weakSelf.actionHandle(weakSelf.value)
            }
        }
        
        rightView.setTarget(greenDefine.GreenInfoFieldStep_RightImage.tint(greenDefine.GreenInfoFieldStep_ButtonTintColor)) { (button) in
            weakSelf.value = weakSelf.value + weakSelf.step;
            if(weakSelf.actionHandle != nil)
            {
                weakSelf.actionHandle(weakSelf.value)
            }
        }
        tfContent.textAlignment = .center;
    }

    
    //-------------------------------------------------------Public function
    open func target(action :  @escaping ((Double)-> Void))
    {
        self.actionHandle = action ;
    }

    open var value: Double = 0
    {
        didSet
        {
            tfContent.text = String(value)
            validate()
        }
    }
    
    public func textColor(color : UIColor)
    {
        tfContent.textColor = color
    }
    
    public func tintColor(color : UIColor)
    {
        leftView.setImage(greenDefine.GreenInfoFieldStep_LeftImage.tint(color))
        rightView.setImage(greenDefine.GreenInfoFieldStep_RightImage.tint(color))
    }
    
    
    

    
}
