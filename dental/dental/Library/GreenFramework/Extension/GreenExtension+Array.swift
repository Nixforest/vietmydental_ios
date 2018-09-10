//
//  GreenExtension+String.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import UIKit
public extension Array
{

    mutating func rearrange(from: Int, to: Int) {
            insert(remove(at: from), at: to)
    }
}
