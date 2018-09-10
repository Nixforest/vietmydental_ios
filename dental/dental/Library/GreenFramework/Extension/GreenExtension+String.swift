//
//  GreenExtension+String.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import UIKit
public extension String
{
    public func setRequired() -> NSMutableAttributedString
    {
        if self.characters.last != "*" {
            let location = self.length
            let myString =  self.appending(" *")
            let attributeString = NSMutableAttributedString(string: myString)
            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange.init(location: location, length: 2))
            return attributeString
        }
        else {
            let location = self.length - 2
            let attributeString = NSMutableAttributedString(string: self)
            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange.init(location: location, length: 2))
            return attributeString
        }
    }
    
    
    
    public func hexColor() -> UIColor {
        let hexint = Int(intFromHexString(self))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
    }
    
    fileprivate func intFromHexString(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: hexStr)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    
    public func image() -> UIImage
    {
        if(self.length == 0)
        {
        }
        
        if(UIImage.init(named: self) != nil)
        {
            return UIImage.init(named: self)!
        }
        return UIImage.init()
    }
    
    public func imageTint(_ color : UIColor) -> UIImage
    {
        return image().tint(color)
    }
    
    
    public func translate() -> String
    {
        
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    
    mutating func appendPrefix(_ value : String)
    {
        self = self.replacingOccurrences(of: "value", with: "")
        self = value.appending(self);
    }
    
    
    public func dataValue() -> Data
    {
        return self.data(using:String.Encoding.utf8, allowLossyConversion: true)!
    }
    
    
    public func acsiiDataValue() -> Data
    {
        return self.data(using:String.Encoding.ascii, allowLossyConversion: true)!
    }
    
    public func lossyValue() -> String
    {
        return (NSString(data: acsiiDataValue(), encoding:String.Encoding.utf8.rawValue)! as String).replacingOccurrences(of: " ", with: "")
    }
    
    
    public var length: Int
    {
        return self.characters.count
    }
    
    
    public func intValue()-> Int
    {
        if let myNumber = NumberFormatter().number(from: self)
        {
            return myNumber.intValue
        }
        else
        {
            return 0
        }
    }
    
    public func toBool() -> Bool
    {
        switch self
        {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0","2":
            return false
        default:
            return false
        }
    }
    func capitalizingFirstLetter() -> String {
        var result = ""
//        let split = self.capitalized.split(separator: " ")
//        for  i in 0..<split.count{
//            let str = split[i]
//            let t = str.prefix(1)
//            if i == 0 || i == split.count - 1{
//                    result.append(contentsOf: t)
//            }
//            
//            
//        }
        return result
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    

}
