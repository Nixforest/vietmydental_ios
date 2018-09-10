//
//  MasterObject.swift
//  dental
//
//  Created by Lâm Phạm on 1/14/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import Foundation

open class MasterObject: NSObject {
    
    var id: String = ""
    var name: String = ""
    var data: Any!
    
    //offline properties
    var desc = ""
    var childs = [MasterObject]()
    
    override public init() {
    }
    
    public init(dict: NSDictionary) {
        super.init()
        
        self.id = dict.object(forKey: "id") as! String
        self.name = dict.object(forKey: "name") as! String
        self.data = dict.object(forKey: "data")
        if let list = self.data as? [NSDictionary] {
            self.childs = MasterObject.listed(dicts: list)
        }
        if let str = self.data as? String {
            self.desc = str
        }
    }
    class func listed(dicts: [NSDictionary]) -> [MasterObject] {
        var output = [MasterObject]()
        for dict in dicts {
            let obj = MasterObject.init(dict: dict)
            output.append(obj)
        }
        return output
    }
}








