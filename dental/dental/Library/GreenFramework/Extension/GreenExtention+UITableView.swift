//
//  GreenExtention+UITableView.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import UIKit
public extension UITableView
{
    public func setIdentifier(_ identifier : String)
    {
        register(UINib.init(nibName: identifier , bundle: Bundle.main), forCellReuseIdentifier: identifier);
    }
    
    public func getIdentiferCell(_ identifier : String) -> UITableViewCell
    {
       return  dequeueReusableCell(withIdentifier: identifier)!
    }
    }
