//
//  G03F00S01TableViewCell.swift
//  dental
//
//  Created by Lâm Phạm on 10/4/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G03F00S01TableViewCell: UITableViewCell {

    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadReport(_ report: ConfigExtBean) {
        lbDate.text = report.name
        for data in report.getListData() {
            switch data.id {
            // show status icon
            case DomainConst.ITEM_STATUS:
                showIcon(byStatusID: data.getStringData())
                break
            // load status text
            case DomainConst.ITEM_STATUS_STR:
                lbStatus.text = data.getStringData()
                break
            default:
                break
            }
        }
    }
    
    func loadAgentReport(_ report: ConfigExtBean) {
        lbDate.text = report.name
        for data in report.getListData() {
            switch data.id {
            // show status icon
            case DomainConst.ITEM_STATUS:
                showIcon(byStatusID: data.getStringData())
                break
            // load status text
            case DomainConst.ITEM_STATUS_STR:
                lbStatus.text = data.getStringData()
                break
            default:
                break
            }
        }
    }
    
    func showIcon(byStatusID status: String) {
        let status = DailyReportStatus.getStatus(byID: status)
        imgStatus.image = status.getImage()
    }
    
}












