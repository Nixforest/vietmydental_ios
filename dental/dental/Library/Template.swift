//
//  ApplicationStyleDefine.swift
//  MTS
//
//  Created by KieuVan on 2/22/17.
//  Copyright © 2017 InnoTech. All rights reserved.
//

import UIKit

let isIpad  : Bool = UIDevice.current.userInterfaceIdiom == .pad
let isIphone  : Bool = !isIpad
let isPortrait : Bool = UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
let isLandscape:Bool = !isPortrait

let isStatusBarPortrait:Bool = (UIApplication.shared.statusBarOrientation.isPortrait)
let isStatusBarLandscape:Bool = !isStatusBarPortrait

public let  template = ApplicationTemplateInstance.sharedInstance()
@objc open class ApplicationTemplateInstance: NSObject {
    
    var viewRadius      : Float = 4;
    var buttonRadius    : Float = 4;
    
    var successColor    : UIColor!
    var infoColor       : UIColor!
    var dangerColor     : UIColor!
    var warningColor    : UIColor!
    var lineThickness: CGFloat = 0.5
    
    var backgroundAColor    : UIColor!
    var backgroundBColor    : UIColor!
    
    var mainAColor          : UIColor!
    var mainBColor          : UIColor!
    
    var headerACoor         : UIColor!
    var headerBColor        : UIColor!
    var generalTextColor    : UIColor!
    var subTextColor        : UIColor!
    var hightlightTextColor : UIColor!
    var titleTextColor      : UIColor!
    
    var H1Font : UIFont!
    var H2Font : UIFont!
    var H3Font : UIFont!
    var H4Font : UIFont!
    var H5Font : UIFont!
    var H6Font : UIFont!
    var H7Font : UIFont!
    var H8Font : UIFont!
    var H9Font : UIFont!
    
    let MASTER_DATA_CELL_BGND_COLOR = "E8F4FD".hexColor()
    var lineColor = "c8ccd4".hexColor()
    let dateFormat8601 = "yyyy-MM-dd hh:mm:ss"
    let emptyDict = [String: AnyObject]()
    let ERROR_TEXT = "Lỗi"
    let SUCCESS_TEXT = "Thông báo"
    let LOADING_TEXT = "Đang tải dữ liệu"
    let ALERT_TEXT = "Thông báo"
    
    open var gDefine: GreenDefine!

    static var instance: ApplicationTemplateInstance!

    
    class func sharedInstance() -> ApplicationTemplateInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? ApplicationTemplateInstance())
            self.instance.loadTemplace()
            self.instance.overrideGreenStyle()
            self.instance.gDefine = greenDefine
        }
        return self.instance
    }
    
    
    func loadTemplace()
    {
        H1Font = UIFont.systemFont(ofSize: 12)
        H2Font = UIFont.systemFont(ofSize: 13)
        H3Font = UIFont.systemFont(ofSize: 14)
        H4Font = UIFont.systemFont(ofSize: 15)
        H5Font = UIFont.systemFont(ofSize: 16)
        H6Font = UIFont.systemFont(ofSize: 17)
        H7Font = UIFont.systemFont(ofSize: 18)
        H8Font = UIFont.systemFont(ofSize: 19)
        H9Font = UIFont.systemFont(ofSize: 20)

        
        backgroundAColor = "F7F7F7".hexColor()
        backgroundBColor = "f5f5f5".hexColor()

        headerACoor = "1B1D20".hexColor()
        headerBColor = "fb4f63".hexColor()

        mainAColor = "007AFF".hexColor()
        mainBColor = "fb4f63".hexColor()
        
        subTextColor = "9098a9".hexColor()
        generalTextColor = "223254".hexColor()
        hightlightTextColor = "565b63".hexColor()
        titleTextColor = UIColor.white

        successColor = mainAColor
        dangerColor = "fb4f63".hexColor()
        warningColor = "E3B51F".hexColor()

        hightlightTextColor = mainBColor;
//        generalTextColor = UIColor.black;

    }
    
    func overrideGreenStyle()
    {
        
        greenDefine.H1Font = H1Font
        greenDefine.H2Font = H2Font
        greenDefine.H3Font = H3Font
        greenDefine.H4Font = H4Font
        greenDefine.H5Font = H5Font
        greenDefine.H6Font = H6Font

        greenDefine.GreenRadius = Int(viewRadius);
        greenDefine.GreenButton_Radius = Int(buttonRadius);
        
        greenDefine.GreenCheckBox_ImageCheck = UIImage.init(named: "GreenCheckbox_CheckGreenCheckbox_Check")?.tint(mainAColor)
        greenDefine.GreenCheckBox_ImageUncheck = UIImage.init(named: "empty")?.tint(mainAColor)
        
        greenDefine.GreenSubTextColor = subTextColor
        greenDefine.GreenGeneralTextColor = generalTextColor
        greenDefine.GreenHighlightTextColor = hightlightTextColor
        greenDefine.GreenInfoFieldHorizontal_LeftTextStyle = TextStyle.h2Sub
        greenDefine.GreenInfoFieldHorizontal_RightTextStyle = TextStyle.h2General
        greenDefine.GreenInfoView_TitleColor = subTextColor
        greenDefine.GreenInfoView_ContentColor = generalTextColor
        greenDefine.GreenInfoView_LineColor = "313437".hexColor()
        
        
        
        
        greenDefine.GreenInfoFieldSymbol_LineColor = UIColor.clear
        greenDefine.GreenInfoFieldSymbol_TextStyle = TextStyle.h3General
        greenDefine.GreenInfoFieldSymbol_BackgroundColor = UIColor.clear
        greenDefine.GreenInfoFieldSymbol_LeftBackgroundColor = UIColor.white
        greenDefine.GreenInfoFieldSymbol_RightBackgroundColor = UIColor.white
        greenDefine.GreenInfoFieldSymbol_PlacehoderTextColor = generalTextColor
        
        
        
        
        greenDefine.GreenButtonSuccess_BackgroundColor = mainAColor
        greenDefine.GreenButtonSuccess_TitleColor = UIColor.white
        greenDefine.GreenButtonDanger_BackgroundColor = dangerColor
        greenDefine.GreenButtonDanger_TitleColor = UIColor.white
        
    }
}








