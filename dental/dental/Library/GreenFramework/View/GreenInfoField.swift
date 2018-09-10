

//
//  InfoField.swift
//  ERPSwift
//
//  Created by KieuVan on 9/3/16.
//  Copyright © 2016 KieuVan. All rights reserved.
//


import UIKit

open class GreenInfoField: GreenView
{
    @IBOutlet weak var lbTitle: GreenLabel!
    @IBOutlet weak var tvContent: UITextField!
    
    @IBOutlet weak var leadingLine: NSLayoutConstraint!
    @IBOutlet weak var leadingContent: NSLayoutConstraint!
    @IBOutlet weak var leadingTitle: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    
    
    var handle : ((Void)->Void)!
    
    open var title : String!
    {
        set{
            self.lbTitle.text = newValue
        }
        get
        {
            return self.lbTitle.text
        }
    }
    
    
    open var content : String!
        {
        set{
            self.tvContent.text = newValue
        }
        get{
        
            return self.tvContent.text;
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initStyle()
    }
    
    @IBAction func mainTouch(_ sender: Any)
    {
        handle()
    }
    @IBOutlet weak var tightButton: GreenButtonCenter!
    @IBOutlet weak var rightWidthContraint: NSLayoutConstraint!
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    @IBOutlet weak var btHeader: UIButton!
        
    open override func awakeFromNib() {
        super.awakeFromNib()
        initStyle()
    }
    @IBOutlet weak var btMain: UIButton!
    @IBOutlet weak var treadingLine: NSLayoutConstraint!
    
    @IBAction func titleAction(_ sender: Any) {
    }
    override open func initStyle()
    {
        super.initStyle()
        
        btMain.isHidden = true
        self.view.backgroundColor = greenDefine.GreenInfoView_BackgroundColor
        lbTitle.backgroundColor = UIColor.clear
        tvContent.backgroundColor = UIColor.clear
        tvContent.textAlignment = .justified        
        lineView.backgroundColor = greenDefine.GreenInfoView_LineColor
        lineView.alpha = 0.5
        
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: tvContent.frame.height))
        tvContent.leftView = paddingView
        rightWidthContraint.constant = 0 ;
        setPadding(10)
    }
    
    func setRight(_ image : UIImage,completion :  @escaping ((Void)->Void) )
    {
        handle = completion
        btMain.isHidden = false
        btMain.isUserInteractionEnabled = true
        rightWidthContraint.constant = 40 ;
        tightButton.setImage(image)
        tightButton.setTarget { (button) in
            completion()
        }
    }
    
    func setRight(_ image : UIImage,enableField : Bool,completion :  @escaping ((Void)->Void) )
    {
        tvContent.isUserInteractionEnabled = enableField
        btHeader.isHidden = enableField;
        setRight(image, completion: completion)
    }

    func setRight(image : UIImage)
    {
        tightButton.setImage(image)
        rightWidthContraint.constant = 40 ;
    }
    
    
    func setPadding(_ value : CGFloat )
    {
        leadingLine.constant = value
        treadingLine.constant = value
        leadingTitle.constant = value
        leadingContent.constant = value
    }
    
}
