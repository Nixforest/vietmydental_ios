//
//  G04F01S01VC.swift
//  dental
//
//  Created by Lâm Phạm on 10/15/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework
import BarcodeScanner

class G04F01S01VC: ChildExtViewController {
    
    var scanVC:BarcodeScannerController!
    
    var handler: ((String) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Scan")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        settingCamera()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    //MARK: -
    func didGetCode(didGetCode: @escaping((String) -> Void)) {
        handler = didGetCode
    }
    func settingCamera() {
        scanVC = BarcodeScannerController()
        scanVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scanVC.codeDelegate = self
        scanVC.errorDelegate = self
        self.addChildViewController(scanVC)
        self.view.addSubview(scanVC.view)
    }

    func showCode(code:String, type:String, controller:BarcodeScannerController) {
        let alertController = UIAlertController(title: type, message: code, preferredStyle: UIAlertControllerStyle.alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            controller.resetWithError()
        }
        alertController.addAction(okAction)
        self.childViewControllers[0].present(alertController, animated: true, completion: nil)
    }

    func showCode(code: String) {
        weak var weakself = self
        let alertController = UIAlertController(title: "Kết quả", message: code, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            weakself?.scanVC.reset()
//            self.delegate.g04F01S01VCDidGetCode(code)
            self.handler(code)
        }
        alertController.addAction(okAction)
        self.childViewControllers[0].present(alertController, animated: true, completion: nil)
    }

}

extension G04F01S01VC: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        showCode(code: code)
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        weak var weakself = self
        
        let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            weakself?.scanVC.resetWithError()
        }
    }
}













