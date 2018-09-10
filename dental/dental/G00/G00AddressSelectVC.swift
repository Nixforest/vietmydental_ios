//
//  G00AddressSelectVC.swift
//  project
//
//  Created by SPJ on 10/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G00AddressSelectVC: ChildExtViewController {
    // MARK: Properties
    /** Information table view */
    var tblInfo:            UITableView         = UITableView()
    /** Data */
    var _data:              [ConfigBean]        = [ConfigBean]()
    /** Original data */
    var _originData:        [ConfigBean]        = [ConfigBean]()
    /** Search control */
    var _searchController:  UISearchController  = UISearchController(searchResultsController: nil)
    /** Selected value */
    var _selectedValue:     String              = DomainConst.BLANK
    
    // MARK: Static values
    // MARK: Constant
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.createNavigationBar(title: DomainConst.CONTENT00442)
    }
    
    /**
     * Notifies the view controller that its view is about to be removed from a view hierarchy.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _searchController.dismiss(animated: false,
                                  completion: nil)
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
        createSearchController()
        // Create information table view
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
        self.view.addSubview(tblInfo)
    }
    
    /**
     * Update children views
     */
    override func updateChildrenViews() {
        super.updateChildrenViews()
        // Update information table view
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
    public func setData(data: [ConfigBean], selectedValue: String) {
        self._data = data
        self._selectedValue = selectedValue
        self._originData = data
        tblInfo.reloadData()
    }
    
    // MARK: Layout
    // MARK: Information table view
    private func createInfoTableView() {
//        if (self.navigationController?.isNavigationBarHidden)! {
//            tblInfo.frame = CGRect(x: 0, y: 0,
//                                   width: UIScreen.main.bounds.width,
//                                   height: UIScreen.main.bounds.height)
//        } else {
//            tblInfo.frame = CGRect(x: 0, y: 0,
//                                   width: UIScreen.main.bounds.width,
//                                   height: UIScreen.main.bounds.height - GlobalConst.NAVIGATION_BAR_HEIGHT)
//        }
        tblInfo.frame = CGRect(x: 0, y: 0,
                               width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height - getTopHeight())
        tblInfo.dataSource = self
        tblInfo.delegate = self
        tblInfo.reloadData()
    }
    
    private func updateInfoTableView() {
        CommonProcess.updateViewPos(
            view: tblInfo,
            x: 0, y: 0,
            w: UIScreen.main.bounds.width,
            h: UIScreen.main.bounds.height - getTopHeight())
    }
    
    // MARK: Search controller
    private func createSearchController() {
        _searchController.searchResultsUpdater = self
        _searchController.hidesNavigationBarDuringPresentation = false
        _searchController.searchBar.placeholder = DomainConst.CONTENT00287
        _searchController.dimsBackgroundDuringPresentation = false
        tblInfo.tableHeaderView = _searchController.searchBar
    }
    
    deinit {
        self._searchController.view.removeFromSuperview()
    }
}

// MARK: Protocol - UITableViewDataSource
extension G00AddressSelectVC: UITableViewDataSource {
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
        return _data.count
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        if indexPath.row < self._data.count {
            let data = self._data[indexPath.row]
            cell.textLabel?.text = data.name
            cell.textLabel?.font = GlobalConst.BASE_FONT
            if data.id == _selectedValue {
                cell.textLabel?.textColor = UIColor.red
            } else {
                cell.textLabel?.textColor = UIColor.black
            }
        }
        return cell
    }
}

// MARK: Protocol - UITableViewDelegate
extension G00AddressSelectVC: UITableViewDelegate {
    /**
     * Tells the delegate that the specified row is now selected.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BaseModel.shared.sharedString = _data[indexPath.row].id
        self.backButtonTapped(self)
    }
}

// MARK: Protocol - UISearchResultsUpdating
extension G00AddressSelectVC: UISearchResultsUpdating {
    /**
     * Called when the search bar becomes the first responder or when the user makes changes inside the search bar.
     */
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let keyword = searchText.removeSign().lowercased()
            _data = _originData.filter { $0.name.removeSign().lowercased()
.contains(keyword) }
        } else {
            _data = _originData
        }
        self.tblInfo.reloadData()
    }
}
