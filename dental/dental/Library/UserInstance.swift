//
//  UserInstance.swift
//  MiBook
//
//  Created by Dũng Lê on 7/31/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit
import harpyframework

let  userInstance = UserInstance.sharedInstance()

let KEY_USERNAME = "LOGIN_RESIDE_BOOK_USERNAME"
let KEY_PASSWORD = "LOGIN_RESIDE_BOOK_PASSWORD"
let KEY_BUSINESS_ID = "BUSINESS_ID_BY_USER_"
let KEY_INTRO_OPENED = "RESIDE_BOOK_INTRO_OPENED"

class UserInstance: NSObject {
    
    static var instance: UserInstance!
    
    var userLogin: LoginUser!
    var UserName: String = ""
    var dateLogin: Date!
    var isLogin = false
    var userNameLogin = ""
    var passwordLogin = ""
    
    class func sharedInstance() -> UserInstance {
        if(self.instance == nil) {
            self.instance = (self.instance ?? UserInstance())
        }
        return self.instance
    }
    
    func isFirstLogin() -> Bool {
      return  userInstance.isLogin
    }
    
    func setIsFirsLogin(isFirstLogin : Bool) {
        userInstance.isLogin = isFirstLogin
    }
    func setObject(object: Any, forKey key: String) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    func removeObject(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    func getObject(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    func getKeyBusinessID(user: String) -> String {
        var output = ""
        output = KEY_BUSINESS_ID + user
        return output
    }
    
    func getStringFromDate(date: Date, withFormat format: String) -> String {
        var output: String!
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "UTC")
        output = formatter.string(from: date)
        return output
    }
    
    func getCurrentDate() -> Date {
        return Date().addingTimeInterval(25200)
    }
    
    
    func getStringBody(parameter: Dictionary <String, AnyObject>) -> String {
        var output = ""
        for  (k,v) in  parameter {
            output = output + "\"\(k)\": \"\(v)\","
        }
        output = "q={\(output) \"platform\":\"0\", \"token\": \"\(BaseModel.shared.getUserToken())\"}"
        output = output.replacingOccurrences(of: "\"(", with: "[")
        output = output.replacingOccurrences(of: ")\"", with: "]")
        return output
    }
}
