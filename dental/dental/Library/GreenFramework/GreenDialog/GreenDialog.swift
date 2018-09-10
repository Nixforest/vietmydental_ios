//
//  GreenDialog.swift
//  NCMobileERP_iOS
//
//  Created by Lê Dũng on 6/22/17.
//  Copyright © 2017 nhatcuong. All rights reserved.
//

import UIKit



enum GreenDialogType : Int
{
    case info = 0
    case success = 1
    case warning = 2
    case select = 3
}


let  greenDialog = GreenDialog.sharedInstance()
class GreenDialog: NSObject
{
    static var instance: GreenDialog!
    
    private var containView = UIView()
    private var alphaView = UIView()
    private var targetView : UIView?
    
    
    
    class func sharedInstance() -> GreenDialog
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? GreenDialog())
        }
        return self.instance
    }
    
    
    func showDialog(type : GreenDialogType, completion :((Int)->Void))
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootView = appDelegate.window?.rootViewController?.view
        
        
        
        rootView?.addSubview(self.alphaView)
        rootView?.setLayout(self.alphaView)
        
        rootView?.addSubview(self.containView)
        rootView?.setLayout(self.containView)
        alphaView.backgroundColor = UIColor.black
        alphaView.alpha = 0.12
        
        self.targetView = DialogInfoView()
        self.targetView?.frame = CGRect.init(x: 10, y: 100, width: 300, height: 284)
        self.containView.addSubview(self.targetView!)

        containView.isHidden = true;
        alphaView.isHidden = true;


        
        UIView.transition(with: self.containView, duration: 0.25, options: .transitionCrossDissolve, animations: { _ in
            self.containView.isHidden = false;
            self.alphaView.isHidden = false;

        }, completion: nil)


    }
    
    func hideDialog()
    {
        

        
        
        UIView.transition(with: self.containView, duration: 0.25, options: .transitionCrossDissolve, animations: { _ in
        self.containView.isHidden = true;
            self.alphaView.isHidden = true;

        }, completion: { (result) in
            
            self.alphaView.removeFromSuperview()
            self.containView.removeFromSuperview()
            self.targetView?.removeFromSuperview()
            self.targetView = nil ;

        })

    }
}



extension UIView
{
    func showDialogView(view : UIView)
    {
        view.tag = 1003
        
        let containerView  = UIView.init();
        containerView.tag = 1001;
        
        containerView.frame = self.bounds
        self.addSubview(containerView)
        self.setLayout(containerView)

        let alphaView = UIView.init()
        alphaView.backgroundColor = UIColor.lightGray
        alphaView.alpha = 0.25;
        alphaView.frame = containerView.frame
        alphaView.tag = 1002
        
        containerView.addSubview(alphaView)
        containerView.setLayout(alphaView)
        containerView.addSubview(view)
    }
    
    func hideDialogView()
    {
        if let containerView = self.viewWithTag(1001)
        {
            let dialogView = containerView.viewWithTag(1003)
            if(dialogView != nil)
            {
                dialogView?.removeFromSuperview()
            }
            
            if let alphaView = containerView.viewWithTag(1002)
            {
                alphaView.removeFromSuperview()
            }
        }
    }
}
