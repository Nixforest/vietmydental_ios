//
//  BaseView.swift
//  CustomControl
//
//  Created by Lâm Phạm on 5/21/18.
//  Copyright © 2018 lampham. All rights reserved.
//

import UIKit

class BaseView: UIView {

    @IBOutlet  open  var view: UIView!
    
    func getClassName(object: Any) -> String {
        return String(describing: type(of: (object as AnyObject))).replacingOccurrences(of:"", with:".Type")
    }
    deinit {
        let str = getClassName(object: self) + " deinit"
        print(str)
    }
    
    private func setupXib() {
        view = loadViewFromNib()
        view.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        view.frame = bounds
        addSubview(view)
        self.setFullLayout(view)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        firstInit()
    }
    
    open func firstInit() {
        
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:self.getClassName(object: self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
        firstInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    func setFullLayout(_ view : UIView)  {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0))
    }

}
