//
//  GreenExtension+UIViewController.swift
//  Green
//
//  Created by KieuVan on 2/14/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import Foundation
import UIKit

public extension UIViewController
{
    public func registerDismissKeyboardWhenTouchScreen()
    {
        let tapGesture  = UITapGestureRecognizer.init(target: self, action: #selector(touched))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc fileprivate func touched()
    {
        self.setEditing(false, animated: true)
    }
    
    public func regisLeft(_ image : UIImage, completion : @escaping (()->Void))
    {
        let leftItem : GreenButtonCenter  = GreenButtonCenter.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        leftItem.setImage(image)
        let buttonItem = UIBarButtonItem.init(customView: leftItem)
        self.navigationItem.leftBarButtonItem = buttonItem
        leftItem.setTarget { (button) in
            completion()
        }
    }
    
    public func regisRight(_ image : UIImage, completion : @escaping (()->Void))
    {
        let leftItem : GreenButtonCenter  = GreenButtonCenter.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        leftItem.setImage(image)
        let buttonItem = UIBarButtonItem.init(customView: leftItem)
        self.navigationItem.rightBarButtonItem = buttonItem
        leftItem.setTarget { (button) in
            completion()
        }
    }
    
    func push(_ target : UIViewController)
    {
        navigationController?.pushViewController(target, animated: true)
    }
    
    func present(_ target : UIViewController,competion: @escaping ((Void)->Void))
    {
        present(target, animated: true) {
            competion()
        }
    }
    
    func presentWithNavi(_ target : UIViewController,competion: @escaping ((Void)->Void))
    {
        let navi = UINavigationController();
        navi.viewControllers = [target]
        present(navi) { () in
            competion()
        }
    }

    func dismiss()
    {
        dismiss(animated: true) {
        }
    }
    
    

    
}
