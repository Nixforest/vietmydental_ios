//
//  ListAgentTableViewCell.swift
//  dental
//
//  Created by Lâm Phạm on 8/1/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class ListAgentTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadAgent(_ agent: ConfigBean) {
        lb.text = agent.name
//        if agent.isSelected {
//            imgCheck.alpha = 1
//        } else {
//            imgCheck.alpha = 0
//        }
    }
    func select() {
        imgCheck.alpha = 1
    }
    
    func notSelect() {
        imgCheck.alpha = 0
    }
}
