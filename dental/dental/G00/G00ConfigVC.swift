//
//  G00ConfigVC.swift
//  dental
//
//  Created by SPJ on 2/7/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G00ConfigVC: BaseParentViewController {
    // MARK: Properties
    /** Information table view */
    var _tblInfo:            UITableView             = UITableView()
    
    // MARK: Static values
    // MARK: Constant
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Navigation
        self.createNavigationBar(title: DomainConst.CONTENT00128)
    }
    
    /**
     * Handle update constants
     */
    override func updateConst() {
        super.updateConst()
    }
    
    /**
     * Create children views
     */
    override func createChildrenViews() {
        super.createChildrenViews()
        createInfoTableView()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        self.view.addSubview(_tblInfo)
    }
    
    /**
     * Update children views
     */
    override func updateChildrenViews() {
        super.updateChildrenViews()
        updateInfoTableView()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                break
            default:
                break
            }
            
            break
        default:
            break
        }
    }
    
    // MARK: Event handler
    
    // MARK: Logic
    
    // MARK: Layout
    // MARK: Information table view
    private func createInfoTableView() {
        _tblInfo.frame = CGRect(x: 0, y: 0,
                                width: UIScreen.main.bounds.width,
                                height: UIScreen.main.bounds.height)
        _tblInfo.dataSource = self
        _tblInfo.delegate = self
//        _tblInfo.separatorStyle = .none
    }
    
    private func updateInfoTableView() {
        CommonProcess.updateViewPos(
            view: _tblInfo,
            x: 0, y: 0,
            w: UIScreen.main.bounds.width,
            h: UIScreen.main.bounds.height)
    }
}

// MARK: Protocol - UITableViewDataSource
extension G00ConfigVC: UITableViewDataSource {
    /**
     * Asks the data source to return the number of sections in the table view.
     * - returns: 1 section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     * Tells the data source to return the number of rows in a given section of a table view.
     * - returns: List information count
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return 2
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = DomainConst.CONTENT00139
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.text = DomainConst.VERSION_CODE_WITH_NAME
                cell.detailTextLabel?.font = GlobalConst.BASE_FONT
                cell.imageView?.image = ImageManager.getImage(named: DomainConst.INFORMATION_IMG_NAME, margin: GlobalConst.MARGIN_CELL_X)
                cell.imageView?.contentMode = .scaleAspectFit
            case 1:
                cell.textLabel?.text = DomainConst.CONTENT00441
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.text = DomainConst.BLANK
                cell.detailTextLabel?.font = GlobalConst.BASE_FONT
                cell.imageView?.image = ImageManager.getImage(named: DomainConst.VERSION_TYPE_ICON_IMG_NAME, margin: GlobalConst.MARGIN_CELL_X)
                cell.imageView?.contentMode = .scaleAspectFit
            default:
                break
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: Protocol - UITableViewDelegate
extension G00ConfigVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: break
            case 1:
                self.updateVersionAppStore()
            default:
                break
            }
        default:
            break
        }
    }
}
