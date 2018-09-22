//
//  ConfigExtBean.swift
//  dental
//
//  Created by SPJ on 2/2/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class ConfigExtBean: ConfigBean {
    /** Data */
    var _dataStr:           String                  = DomainConst.BLANK
    var _dataExt:           [ConfigExtBean]         = [ConfigExtBean]()
    var _dataObj:           [String: AnyObject]     = [String: AnyObject]()
    var _dataArrObj:        [[String: AnyObject]]   = [[String: AnyObject]]()
    /** Select Status */
//    var isSelected: Bool            = false
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public override init(jsonData: [String: AnyObject]) {
        super.init(jsonData: jsonData)
        if let str = jsonData[DomainConst.KEY_DATA] as? String {
            self._dataStr = str
        }
        
        if let list = jsonData[DomainConst.KEY_DATA] as? [[String: AnyObject]] {
            for item in list {
                self._dataExt.append(ConfigExtBean(jsonData: item))
            }
        }
        
        if let obj = jsonData[DomainConst.KEY_DATA] as? [String: AnyObject] {
            self._dataObj = obj
        }
        
        if let arr = jsonData[DomainConst.KEY_DATA] as? [[String: AnyObject]] {
            self._dataArrObj = arr
        }
    }
    
    /**
     * Get string data
     * - returns: String data
     */
    public func getStringData() -> String {
        return self._dataStr
    }
    
    /**
     * Get object data
     * - returns: [String: AnyObject] value
     */
    public func getObjData() -> [String: AnyObject] {
        return self._dataObj
    }
    
    /**
     * Get list data
     * - returns: [ConfigExtBean] value
     */
    public func getListData() -> [ConfigExtBean] {
        return self._dataExt
    }
    
    override public init() {
        super.init()
    }
    
    /**
     * Coopy contructor
     * - parameter copy: Object to copy
     */
    public init(copy: ConfigExtBean) {
        super.init(id: copy.id, name: copy.name)
        self._dataStr = copy._dataStr
        for item in copy._dataExt {
            self._dataExt.append(ConfigExtBean.init(copy: item))
        }
        
        // MARK: To do - Copy array
    }
    
    /**
     * Get data by id
     * - parameter id: Id of item
     * - returns: Value of item
     */
    public func getData(id: String) -> String {
        for item in self._dataExt {
            if item.id == id {
                return item._dataStr
            }
        }
        return DomainConst.BLANK
    }
}
