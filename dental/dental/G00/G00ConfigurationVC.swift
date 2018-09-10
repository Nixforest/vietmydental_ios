//
//  ConfigurationViewController.swift
//  project
//
//  Created by Lâm Phạm on 9/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework

//++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//class G00ConfigurationVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
class G00ConfigurationVC: ParentViewController, UITableViewDelegate, UITableViewDataSource {
//-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
    // MARK: Properties
    /** Search bar */
    @IBOutlet weak var searchBar: UISearchBar!
    /** Config view */
    @IBOutlet weak var configView: UIView!
    /** Config table view */
    @IBOutlet weak var configTableView: UITableView!
    
    // MARK: Actions
    //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//    /**
//     * Handle when tap menu item
//     */
//    func asignNotifyForMenuItem() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.gasServiceItemTapped(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_GAS_SERVICE_ITEM),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(issueItemTapped(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_ISSUE_ITEM),
//                                               object: nil)
//    }
    //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
    
    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//        asignNotifyForMenuItem()
        //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
        
        // Config view
        configView.translatesAutoresizingMaskIntoConstraints = true
        configView.frame = CGRect(
            x: 0,
            y: configView.frame.minY,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height)
        
        // Config table view
        configTableView.backgroundColor = GlobalConst.BACKGROUND_COLOR_GRAY
        configTableView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height)
        searchBar.placeholder = DomainConst.CONTENT00128
        
        // Search bar
        searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchBar.frame = CGRect(
            x: 0,
            y: searchBar.frame.minY,
            width: self.view.frame.size.width,
            height: searchBar.frame.size.height)
        
        // Setup navigation
        //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00128, isNotifyEnable: true)
        createNavigationBar(title: DomainConst.CONTENT00128)
        //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
    }

    /**
     * Did receive memory warning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return 1
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 2
        switch section {
        case 0:
            return 2
        case 1:
            if BaseModel.shared.checkTrainningMode() {
                return 4
            }
            return 0
        default:
            return 0
        }
    }
    
    /**
     * Handle tap on cell.
     */
    func cellAction(_ sender: UIButton) {
        switch sender.tag {
            case 0:     // Information view
                self.pushToView(name: DomainConst.G00_INFORMATION_VIEW_CTRL)
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ConfigurationTableViewCell.PARENT_WIDTH = GlobalConst.SCREEN_WIDTH
        let cell = tableView.dequeueReusableCell(withIdentifier: DomainConst.CONFIGURATION_TABLE_VIEW_CELL, for: indexPath) as! ConfigurationTableViewCell
        switch indexPath.section {
        case 0:                     // Configuration section
            // Custom cell
            switch (indexPath as NSIndexPath).row {
            case 0:             // Information
                cell.setData(leftImg: DomainConst.INFORMATION_IMG_NAME,
                             name: DomainConst.CONTENT00139,
                             value: DomainConst.VERSION_CODE_WITH_NAME)
                
            case 1:             // Information
                cell.setData(leftImg: DomainConst.VERSION_TYPE_ICON_IMG_NAME,
                             name: DomainConst.CONTENT00441,
                             value: DomainConst.BLANK)
            default:
                break
                
            }
        case 1:                     // Test section
            if BaseModel.shared.checkTrainningMode() {
                switch indexPath.row {
                case 0:         // Test google map
                    cell.setData(leftImg: DomainConst.INFORMATION_IMG_NAME,
                                 name: "Test Google Map",
                                 value: DomainConst.BLANK)
                case 1:         // Test QR code
                    cell.setData(leftImg: DomainConst.INFORMATION_IMG_NAME,
                                 name: "Test QR code",
                                 value: DomainConst.BLANK)
                case 2:         // Test QR code
                    cell.setData(leftImg: DomainConst.INFORMATION_IMG_NAME,
                                 name: "Test Loading",
                                 value: DomainConst.BLANK)
                case 3:         // Test QR code
                    cell.setData(leftImg: DomainConst.INFORMATION_IMG_NAME,
                                 name: "Test multi-device",
                                 value: DomainConst.BLANK)
                default:
                    break
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell //ConfigurationTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:                     // Configuration section
            switch indexPath.row {
            case 0:
                self.pushToView(name: DomainConst.G00_INFORMATION_VIEW_CTRL)
            case 1:
                self.updateVersionAppStore()
            default:
                break
            }
            break
        case 1:                     // Test section
            switch indexPath.row {
            case 0:
                testGoogleMap()
            case 1:
                testQRCode()
            case 2:
                testLoadingView()
            case 3:
                testMultiDevice()
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat.leastNormalMagnitude
        return 50
    }
    
    private func testGoogleMap() {
        let googleMap = GoogleMapVC(nibName: GoogleMapVC.theClassName, bundle: nil)
        self.navigationController?.pushViewController(googleMap, animated: true)
    }
    
    private func testQRCode() {
        let frameworkBundle = Bundle(identifier: DomainConst.HARPY_FRAMEWORK_BUNDLE_NAME)
        let scan = ScanCodeVC(nibName: ScanCodeVC.theClassName, bundle: frameworkBundle)
        self.navigationController?.pushViewController(scan, animated: true)
    }
    
    private func testLoadingView() {
        let view = LoadingViewVC(nibName: LoadingViewVC.theClassName, bundle: nil)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    private func testMultiDevice() {
        let view = MultiDeviceVC(nibName: MultiDeviceVC.theClassName, bundle: nil)
        self.navigationController?.pushViewController(view, animated: true)
    }
}
