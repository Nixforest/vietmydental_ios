//
//  Service.swift
//  dental
//
//  Created by Lâm Phạm on 1/11/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import Alamofire
import harpyframework

class APIResponse: MasterModel {
    public static let NO_CONNECTION_CODE = -1
    
    var status: Int = 0
    var message: String = "Lỗi"
    var data: Any!
    var code: Int = 0
    var isDisconnected = false
    var error: Bool = false
    
    override init() {
        super.init()
    }
    
    override init(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
    }
}

let  serviceInstance = Service.sharedInstance()
class Service: NSObject {

    static var instance: Service!

    class func sharedInstance() -> Service {
        if(self.instance == nil) {
            self.instance = (self.instance ?? Service())
        }
        return self.instance
    }

    private func processReponse(response: DataResponse<Any>) -> APIResponse {
        if(response.result.isSuccess) {
            let resp = APIResponse.init(dictionary: response.result.value as! NSDictionary)
            if resp.data == nil {
                resp.error = true
            } else {
                resp.error = false
            }
            return resp
        } else {
            return APIResponse.init()
        }
    }


    private func getStringParam(parameter: Dictionary <String, AnyObject>) -> String {
        var output = ""
        for  (k,v) in  parameter {
            output = output + "\"\(k)\": \"\(v)\","
        }
        output = "q={\(output) \"platform\":\"0\", \"token\": \"\(ServiceConfig.shared.token)\"}"
        output = output.replacingOccurrences(of: "\"(", with: "[")
        output = output.replacingOccurrences(of: ")\"", with: "]")
        return output
    }

    func request(api: APIFunctions, method: HTTPMethod, parameter: Dictionary<String, AnyObject>, success: @escaping((APIResponse) -> Void), failure: @escaping((APIResponse) -> Void)) {

        if !CommonProcess.isConnectNetwork() {
            let resp = APIResponse()
            resp.code = APIResponse.NO_CONNECTION_CODE
            resp.message = "Vui lòng kiểm tra kết nối mạng"
            resp.isDisconnected = true
            failure(resp)
            return
        }
        
        let strParam = getStringParam(parameter: parameter)
        var strURL = ""
        strURL = ServiceConfig.shared.url.appending(api.rawValue)

        print("=======request")
        print(strURL)
        print(strParam)

        let serverUrl: URL = URL.init(string: strURL)!
        var request = URLRequest(url: serverUrl)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(30)
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.httpBody = strParam.data(using: String.Encoding.utf8)

        Alamofire.request(request as URLRequestConvertible).responseJSON { (response) in
            print("===========response")
            print(response as Any)
            let apiResponse = self.processReponse(response: response)
            if (apiResponse.error == false) {
                success(apiResponse)
            }
            else {
                failure(apiResponse)
            }
        }
    }


}

/**
 * Extension Base Request using Alamofire with completion block
 */
extension BaseRequest {
    func execute(completionHandler: @escaping((APIResponse) -> Void)) {
        if !CommonProcess.isConnectNetwork() {
            let resp = APIResponse()
            resp.code = APIResponse.NO_CONNECTION_CODE
            resp.message = "Vui lòng kiểm tra kết nối mạng"
            resp.isDisconnected = true
            completionHandler(resp)
            return
        }
        print("===== URL REQUEST \(self.url) =====")
        print("Body: \(self.data)")
        let serverUrl: URL = URL.init(string: self.url)!
        var request = URLRequest(url: serverUrl)
        request.httpMethod = self.reqMethod
        request.timeoutInterval = TimeInterval(30)
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.httpBody = self.data.data(using: String.Encoding.utf8)
        
        Alamofire.request(request as URLRequestConvertible).responseJSON { (response) in
            print("===== Response \(self.url)")
            print(response as Any)
            completionHandler(self.processReponse(response: response))
            print("===== End request \(self.url) =====")
        }
    }
    
    
    private func processReponse(response: DataResponse<Any>) -> APIResponse {
        guard response.response != nil else {
            let resp = APIResponse.init()
            resp.error = true
            resp.code = APIResponse.NO_CONNECTION_CODE
            resp.message = response.description
            return resp
        }
        if(response.result.isSuccess) {
            let resp = APIResponse.init(dictionary: response.result.value as! NSDictionary)
            resp.code = (response.response?.statusCode)!
            if resp.data == nil {
                resp.error = true
            } else {
                resp.error = false
            }
            return resp
        } else {
            let resp = APIResponse.init()
            resp.error = true
            resp.code = (response.response?.statusCode)!
            resp.message = response.description
            return resp
        }
    }
    
    
    private func getStringParam(parameter: Dictionary <String, AnyObject>) -> String {
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


