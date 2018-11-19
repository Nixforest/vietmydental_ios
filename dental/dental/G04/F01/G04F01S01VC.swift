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
    /** handle getting code */
    func didGetCode(didGetCode: @escaping((String) -> Void)) {
        handler = didGetCode
    }
    /** setting scanner */
    func settingCamera() {
        scanVC = BarcodeScannerController()
        scanVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        scanVC.codeDelegate = self
        scanVC.errorDelegate = self
        self.addChildViewController(scanVC)
        self.view.addSubview(scanVC.view)
    }

}

extension G04F01S01VC: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        let arrContent = code.components(separatedBy: "/")
        if let code = arrContent.last {
            self.handler(code)
            self.backButtonTapped(self)
        }
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        weak var weakself = self
        let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            weakself?.scanVC.resetWithError()
        }
    }
}













