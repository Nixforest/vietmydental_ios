//
//  GreenSwipeView.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/29/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit



enum GreenSwipeType
{
    case text
    case customView
}

enum GreenSwipeScrollDirection
{
    case left
    case right
}








class GreenSwipeView: GreenView , UIScrollViewDelegate{
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var heightContraits: NSLayoutConstraint!
    @IBOutlet weak var rightButton: GreenButtonCenter!
    @IBOutlet weak var leftButton: GreenButtonCenter!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var witdhContraits: NSLayoutConstraint!
    
    
    
    
    var direction : GreenSwipeScrollDirection = .right
    
    
    
    private var timer : Timer!
    private var lastOffset : CGFloat!

    private var isAutoScroll = false;

    private var isScrolling = false;
    private var values : [Any] = []
    private var labels : [Any] = []

    
    @IBOutlet weak var indicator: UIPageControl!
    @IBOutlet weak var btWidthContraits: NSLayoutConstraint!
    var actionHandle : ((Int) -> Void)!

    var index : Int = -1
    
    
    
    open func target(action :  @escaping ((Int)-> Void))
    {
        self.actionHandle = action ;
    }

    override func initStyle() {
        scrollView.delegate = self;
        
        indicator.isHidden = true;
        weak var weakSelf : GreenSwipeView!  = self
        
        leftView.setTarget("GBack".image().tint(UIColor.red)) { (button) in
            
            if(weakSelf.index > 0)
            {
                weakSelf.index = weakSelf.index - 1 ;
                weakSelf.setIndex(value: weakSelf.index)
            }
            
            if(weakSelf.actionHandle != nil)
            {
                weakSelf.actionHandle(weakSelf.index)
            }
        }
        
        rightView.setTarget("GRight".image()) { (button) in

            if(weakSelf.index < weakSelf.labels.count - 1)
            {
                weakSelf.index = weakSelf.index + 1 ;
                weakSelf.setIndex(value: weakSelf.index)
            }

            if(weakSelf.actionHandle != nil)
            {
                weakSelf.actionHandle(weakSelf.index)
            }
        }

        
        
        
    }

    @IBOutlet weak var rightView: GreenButtonCenter!
    @IBOutlet weak var leftView: GreenButtonCenter!
    
    public func set(value : [Any], type  : GreenSwipeType)
    {
        
        values.removeAll()
        
        if(type == .text)
        {
            values.append(contentsOf: value)
            for items in value
            {
                let label = UILabel.init()
                label.text = items as? String;
                label.textAlignment = .center;
                labels.append(label)
                label.backgroundColor = UIColor.lightGray
            }
        }
        else
        {
            labels.append(contentsOf: value)
        }
        
        contenView.verticalView(views: labels as! [UIView])
        scrollView.isScrollEnabled = true;
        scrollView.isPagingEnabled = true
        indicator.numberOfPages = labels.count;
    
    }
    
    public override func layoutSubviews()
    {
        witdhContraits.constant = ( self.frame.size.width - 60 ) * CGFloat(labels.count)
        heightContraits.constant = self.frame.size.height
        scrollView.contentSize = CGSize.init(width: witdhContraits.constant, height: self.frame.size.height)
        
        if(index >= 0)
        {
            setIndex(value: index);
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        print("did scroll")
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        print("begin drag")

        isScrolling = true
        
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        print("begin decelarating")

        isScrolling = true
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        print("end decelarating")

        isScrolling = false;

        
        if(isAutoScroll == true)
        {
            return ;
        }
        
        let value  = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if(value == index)
        {
        }
        else
        {
            weak var weakSelf : GreenSwipeView!  = self
            index = value
            if(weakSelf.actionHandle != nil)
            {
                weakSelf.actionHandle(weakSelf.index)
                indicator.currentPage = index;
            }
        }
    }
    
    public func setIndex(value : Int)
    {
        let unit = witdhContraits.constant/CGFloat(labels.count);
        index = value;
        indicator.currentPage = index
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.scrollView.contentOffset.x = unit * CGFloat(self.index)
            }, completion: nil)
        }
    }
    
    
    public func set(margin : CGFloat)
    {
        btWidthContraits.constant = margin;
    }
    
    
    public func showIndicator (isShow : Bool)
    {
        indicator.isHidden = !isShow;
    }
    
    public func showSrcollIndicator (isShow : Bool)
    {
        scrollView.showsHorizontalScrollIndicator =  isShow
    }
    
    
    deinit {
        timer.invalidate()
    }
    
    func setAutoScroll()
    {
        if(timer != nil)
        {
            timer.invalidate()
        }

        
        isAutoScroll = true;
        scrollUpdate()
        scrollView.isPagingEnabled = false;
    }
    
    func scrollUpdate()
    {
        
    
        
        let unit = witdhContraits.constant/CGFloat(labels.count);

        DispatchQueue.main.async {
            UIView.animate(withDuration: 10, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                
                self.scrollView.contentOffset.x = unit * CGFloat(self.labels.count - 1) - self.scrollView.contentOffset.x
            }, completion: { (completion) in
                
                self.scrollUpdate()
            })
        }

    }
}
