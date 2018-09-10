//
//  SingleLineTableViewCell.swift
//  dental
//
//  Created by Lâm Phạm on 1/22/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit

class SingleLineTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCell.layer.masksToBounds = true
        imgCell.layer.cornerRadius = 22
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCell(title: String, imgName: String) {
        label.text = title
        if let img = UIImage.init(named: imgName) {
            imgCell.image = img
        }
    }
    
}
