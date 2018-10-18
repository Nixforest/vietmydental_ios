//
//  ListConfigBean.swift
//  dental
//
//  Created by SPJ on 2/17/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class ListConfigBean: NSObject {
    // MARK: Properties
    /** Data */
    var _data:      [ConfigExtBean] = [ConfigExtBean]()
    
    // MARK: Methods
    /**
     * Set data
     * - parameter data: Data to set
     */
    public func setData(data: [ConfigExtBean]) {
        self._data = data
    }
    
    /**
     * Get data
     * - returns: Data
     */
    public func getData() -> [ConfigExtBean] {
        return self._data
    }
    
    /**
     * Set data by id
     * - parameter id: Id of item
     * - parameter value: Value of item
     */
    public func setData(id: String, value: String, name: String = DomainConst.BLANK) {
        for item in self._data {
            if item.id == id {
                item._dataStr = value
                return
            }
        }
        // Create new
        let data = ConfigExtBean()
        data.id         = id
        data._dataStr   = value
        data.name       = name
        self._data.append(data)
    }
    
    /**
     * Set data by id
     * - parameter id: Id of item
     * - parameter value: Value of array
     */
    public func setArrayData(id: String, value: [ConfigBean], name: String = DomainConst.BLANK) {
        for item in self._data {
            if item.id == id {
                item.data = value
                return
            }
        }
        
        // Create new
        let data = ConfigExtBean()
        data.id         = id
        data.data       = value
        data.name       = name
        self._data.append(data)
    }
    
    /**
     * Get data by id
     * - parameter id: Id of item
     * - returns: Item object
     */
    public func getData(id: String) -> ConfigExtBean {
        for item in self._data {
            if item.id == id {
                return item
            }
        }
        return ConfigExtBean.init()
    }
    
    /**
     * Get the number of elements in the array
     * - returns: The number of elements in the array
     */
    public func count() -> Int {
        return self._data.count
    }
    
    /**
     * Initializer
     * - parameter jsonData: List of data
     */
    public init(jsonData: [[String: AnyObject]]) {
        for item in jsonData {
            self._data.append(ConfigExtBean(jsonData: item))
        }
    }
    
    public override init() {
        
    }
    
    /**
     * Handle reset string value of all item
     */
    public func resetStrData() {
        for item in self._data {
            item._dataStr = DomainConst.BLANK
        }
    }
    
    public func removeAll() {
        self._data.removeAll()
    }
}
