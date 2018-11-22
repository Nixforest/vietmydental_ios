//
//  BaseParentViewController.swift
//  dental
//
//  Created by SPJ on 1/9/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class BaseParentViewController: ParentExtViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func openLogin() {
        let loginView = G00LoginExtVC(nibName: G00LoginExtVC.theClassName, bundle: nil)
        let nav = UINavigationController.init(rootViewController: loginView)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.present(nav, animated: true, completion: finishOpenLogin)
        }
    }
    
    /**
     * Handle when finish open login screen
     */
    internal func finishOpenLogin() -> Void {
        print("finishOpenLogin")
    }
    
}
