//
//  GreenView.swift
//  GFramework
//
//  Created by KieuVan on 2/14/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit

open  class GreenView: UIView
{

       @IBOutlet  open  var view: UIView!
    func classNameAsString(_ obj: Any) -> String
    {
        return String(describing: type(of: (obj as AnyObject))).replacingOccurrences(of:"", with:".Type")
    }
    
        
    func xibSetup()
    {
        view = loadViewFromNib()
        view.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        view.frame = bounds
        addSubview(view)
        self.setLayout(view)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    initStyle()

    }
    
    open  func initStyle()
    {
        
    }
    open  func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        var nibName = self.classNameAsString(obj: self)
        let deviceModel = UIDevice.current.getDeviceModel()
        if deviceModel == DeviceModel.iPhone5.rawValue {
            nibName = nibName + "~iPhone5"
        }
        
        if Bundle.main.path(forResource: nibName, ofType: "nib") == nil {
            nibName = self.classNameAsString(obj: self)
        }
        
        let nib: UINib? = UINib(nibName: nibName, bundle: bundle)
        let view = nib?.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    public  override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        initStyle()

    }
    
   public required init?(coder aDecoder: NSCoder)
   {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func customViewShadow(_ uiView: UIView) {
        uiView.layer.shadowColor = UIColor.black.cgColor
        uiView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        uiView.layer.shadowOpacity = 0.6
        uiView.layer.shadowRadius = 1.0
        uiView.layer.masksToBounds = false
        uiView.layer.cornerRadius = 6.0
        uiView.clipsToBounds = false
    }
    
    func customViewRadius(_ uiView: UIView) {
        uiView.layer.masksToBounds = false
        uiView.layer.cornerRadius = 6.0
        uiView.clipsToBounds = false
        uiView.layer.borderWidth = 1.0
        uiView.layer.borderColor = UIColor(red:0.00, green:0.66, blue:0.59, alpha:1.0).cgColor
        
    }
    
    
    
}
