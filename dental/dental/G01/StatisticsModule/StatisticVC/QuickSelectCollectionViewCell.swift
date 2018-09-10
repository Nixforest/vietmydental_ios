//
//  QuickSelectCollectionViewCell.swift
//  dental
//
//  Created by Lâm Phạm on 7/31/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit

class QuickSelectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lb: UILabel!
    @IBOutlet weak var viewBorder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBorder.drawRadius(15, color: UIColor.clear, thickness: 0)
    }

    func loadText(_ text: String) {
        lb.text = text
    }
}
