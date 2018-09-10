//
//  G01F03S04ViewController.swift
//  dental
//
//  Created by Lâm Phạm on 3/15/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

class G01F03S04ViewController: ChildExtViewController {
    
    
    @IBOutlet weak var tbView: UITableView!
    
    var amount: String = "0"
    var detailID: String = ""
    var receiptBean: ConfigExtBean!
    var debt:   String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbView.delegate = self
        tbView.dataSource = self
        if receiptBean == nil {
            receiptBean = createNilReceiptBean()
            createRightNavigationItem(title: DomainConst.CONTENT00558,
                                      action: #selector(create(_:)),
                                      target: self)
        } else {
            if canUpdate() {
                createRightNavigationItem(title: DomainConst.CONTENT00558,
                                          action: #selector(create(_:)),
                                          target: self)
            }
        }
        tbView.reloadData()
    }
    
    func canUpdate() -> Bool {
        for bean in receiptBean.getListData() {
            if bean.id == DomainConst.ITEM_CAN_UPDATE {
                if bean._dataStr == DomainConst.NUMBER_ZERO_VALUE {
                    return false
                }
            }
        }
        return true
    }
    
    func createNilReceiptBean() -> ConfigExtBean {
        let output = ConfigExtBean()
        output._dataExt = [ConfigExtBean]()
        
        var bean = ConfigExtBean()
        
        bean.id = DomainConst.ITEM_ID
        bean.name = DomainConst.CONTENT00570
        bean._dataStr = amount
        output._dataExt.append(bean)
        
        bean = ConfigExtBean()
        bean.id = DomainConst.ITEM_CUSTOMER_DEBT
        bean.name = DomainConst.CONTENT00577
        bean._dataStr = debt
        output._dataExt.append(bean)
        
        bean = ConfigExtBean()
        bean.id = DomainConst.ITEM_DISCOUNT
        bean.name = DomainConst.CONTENT00572
        bean._dataStr = ""
        output._dataExt.append(bean)
        
        bean = ConfigExtBean()
        bean.id = DomainConst.ITEM_FINAL
        bean.name = DomainConst.CONTENT00573
        bean._dataStr = ""
        output._dataExt.append(bean)
        
        bean = ConfigExtBean()
        bean.id = DomainConst.ITEM_DESCRIPTION
        bean.name = DomainConst.CONTENT00081
        bean._dataStr = ""
        output._dataExt.append(bean)
        
        return output
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getReceiptRequest() -> CreateReceipt_Request {
        let output = CreateReceipt_Request()
        output.date = CommonProcess.getDateString(date: Date(), format: DomainConst.DATE_TIME_FORMAT_2)
        output.detail_id = self.detailID
        for bean in receiptBean.getListData() {
            switch bean.id {
            case DomainConst.ITEM_DISCOUNT:
                output.discount = bean._dataStr
            case DomainConst.ITEM_DESCRIPTION:
                output.note = bean._dataStr
            case DomainConst.ITEM_FINAL:
                output.final = bean._dataStr
            default:
                break
            }
        }
        return output
    }
    
    //MARK: - Services
    func createReceipt(req: CreateReceipt_Request) {
        serviceInstance.createReceipt(req: req) { (result) in
            let str = CommonProcess.getJSONString(fromDictionary: result.data as NSDictionary)
            
            BaseModel.shared.sharedString = str
//            self.showAlert(message: result.message)
            if result.status == 1 {
                self.showAlert(message: result.message,
                               okHandler: { alert in
                                self.backButtonTapped(self)
                })
            } else {
                self.showAlert(message: result.message)
            }
//            self.backButtonTapped(self)
        }
    }
    func create(_ sender: AnyObject) {
        let req = getReceiptRequest()
        createReceipt(req: req)
    }
    
    
    /**
     * Handle input text
     * - parameter bean: Data of item
     */
    internal func inputText(bean: ConfigExtBean) {
        var title           = DomainConst.BLANK
        var message         = DomainConst.BLANK
        var placeHolder     = DomainConst.BLANK
        var keyboardType    = UIKeyboardType.default
        var value           = DomainConst.BLANK
        switch bean.id {
        case DomainConst.ITEM_NAME:
            title           = bean.name
            value           = bean._dataStr
            break
        case DomainConst.ITEM_DISCOUNT,
             DomainConst.ITEM_FINAL:
            title           = bean.name
            value           = bean._dataStr
            message         = DomainConst.BLANK
            placeHolder     = bean.name
            keyboardType    = UIKeyboardType.numberPad
            break
        default:
            title           = bean.name
            value           = bean._dataStr
            message         = DomainConst.BLANK
            placeHolder     = DomainConst.BLANK
            keyboardType    = UIKeyboardType.default
            break
        }
        var tbxValue: UITextField?

        // Create alert
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        // Add textfield
        alert.addTextField(configurationHandler: { textField -> Void in
            tbxValue = textField
            tbxValue?.placeholder       = placeHolder
            tbxValue?.clearButtonMode   = .whileEditing
            tbxValue?.returnKeyType     = .done
            tbxValue?.keyboardType      = keyboardType
            tbxValue?.text              = value
            tbxValue?.textAlignment     = .center
        })

        // Add cancel action
        let cancel = UIAlertAction(title: DomainConst.CONTENT00202, style: .cancel, handler: nil)

        // Add ok action
        let ok = UIAlertAction(title: DomainConst.CONTENT00008, style: .default) {
            action -> Void in
            if let newValue = tbxValue?.text, !newValue.isEmpty {
                for item in self.receiptBean.getListData() {
                    if item.id == bean.id {
                        bean._dataStr = newValue
                        self.tbView.reloadData()
                    }
                }
            } else {
                self.showAlert(message: DomainConst.CONTENT00551,
                               okHandler: {
                                alert in
                                self.inputText(bean: bean)
                })
            }
        }

        alert.addAction(cancel)
        alert.addAction(ok)
        if let popVC = alert.popoverPresentationController {
            popVC.sourceView = self.view
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getCell(bean: ConfigExtBean) -> UITableViewCell {
        var imagePath = DomainConst.INFORMATION_IMG_NAME
        if let img = DomainConst.VMD_IMG_LIST[bean.id] {
            imagePath = img
        }
        let image = ImageManager.getImage(named: imagePath,
                                          margin: GlobalConst.MARGIN * 2)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = bean.name
        cell.textLabel?.font = GlobalConst.BASE_FONT
        cell.detailTextLabel?.text = bean._dataStr
        cell.detailTextLabel?.font = GlobalConst.BASE_FONT
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.numberOfLines = 0
        if bean._dataStr.isEmpty {
            cell.detailTextLabel?.text = LoginBean.shared.getUpdateText()
            cell.detailTextLabel?.textColor = UIColor.red
        }
        cell.imageView?.image = image
        cell.imageView?.contentMode = .scaleAspectFit
        return cell
    }
}

// MARK: Protocol - UITableViewDataSource
extension G01F03S04ViewController: UITableViewDataSource {
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
        if section == 0 {
            return self.receiptBean.getListData().count
        } else {
            // For future
            return 0
        }
    }
    
    /**
     * Asks the data source for a cell to insert in a particular location of the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row > self.receiptBean.getListData().count {
                return UITableViewCell()
            }
            let data = receiptBean.getListData()[indexPath.row]
            var imagePath = DomainConst.INFORMATION_IMG_NAME
            if let img = DomainConst.VMD_IMG_LIST[data.id] {
                imagePath = img
            }
            // dynamic cell for amount
            switch data.id {
            case DomainConst.ITEM_ID:
                let cell = getCell(bean: data)
                imagePath = DomainConst.VMD_SUM_ICON_IMG_NAME
                cell.imageView?.image = ImageManager.getImage(
                    named: imagePath, margin: GlobalConst.MARGIN * 2)
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            case DomainConst.ITEM_CUSTOMER_DEBT:
                let cell = getCell(bean: data)
                cell.imageView?.image = ImageManager.getImage(
                    named: imagePath, margin: GlobalConst.MARGIN * 2)
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            case DomainConst.ITEM_CUSTOMER_CONFIRMED,
                 DomainConst.ITEM_NEED_APPROVE,
                 DomainConst.ITEM_CAN_UPDATE,
                 DomainConst.ITEM_START_DATE:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.contentView.isHidden = true
                return cell
                
            default:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                cell.textLabel?.text = data.name
                cell.textLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.text = data._dataStr
                cell.detailTextLabel?.font = GlobalConst.BASE_FONT
                cell.detailTextLabel?.lineBreakMode = .byWordWrapping
                cell.detailTextLabel?.numberOfLines = 0
                if data._dataStr.isEmpty {
                    cell.detailTextLabel?.text = LoginBean.shared.getUpdateText()
                    cell.detailTextLabel?.textColor = UIColor.red
                }
                cell.imageView?.image = ImageManager.getImage(
                    named: imagePath, margin: GlobalConst.MARGIN * 2)
                cell.imageView?.contentMode = .scaleAspectFit
                return cell
            }
        case 1:     // For future
            break
        default:
            break
        }
        
        return UITableViewCell()
    }
}

// MARK: Protocol - UITableViewDelegate
extension G01F03S04ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if canUpdate() {
            switch indexPath.section {
            case 0:
                let data = self.receiptBean.getListData()[indexPath.row]
                switch data.id {
                case DomainConst.ITEM_DESCRIPTION,
                     DomainConst.ITEM_DISCOUNT,
                     DomainConst.ITEM_FINAL:
                    inputText(bean: data)
                default:
                    break
                }
                break
            default:
                break
            }
        }
        
    }
    
    /**
     * Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch receiptBean.getListData()[indexPath.row].id {
            case DomainConst.ITEM_CUSTOMER_CONFIRMED,
                 DomainConst.ITEM_NEED_APPROVE,
                 DomainConst.ITEM_CAN_UPDATE,
                 DomainConst.ITEM_START_DATE:
                return 0
            default:
                return UITableViewAutomaticDimension
            }
        default:
            return UITableViewAutomaticDimension
        }
        
    }
}




extension G01F03S04ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nonNumberSet = NSCharacterSet(charactersIn: "0123456789.").inverted
        if let oldString = textField.text {
            let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                          with: string)
            textField.text = newString
        }
        if string.trimmingCharacters(in: nonNumberSet as CharacterSet).length > 0 {
            if (textField.text?.length)! >= 100 && (range.length == 0) {
                return false
            } else {
                return true
            }
        }
        return false
    }
    func textFieldChangeAmountValue(sender: UITextField) {
        var strValue = sender.text?.replacingOccurrences(of: ".", with: "")
        strValue = strValue?.replacingOccurrences(of: ",", with: "")
        let strDecimal = CommonProcess.convertStringDecimal(stringValue: strValue!)
        sender.text = strDecimal
    }
}






