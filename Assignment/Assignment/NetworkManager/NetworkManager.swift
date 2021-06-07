//
//  NetworkManager.swift
//  Assignment
//
//  Created by Srikanth on 04/06/21.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias CompletionHandler = ((_ result: Any?,_ Error: Error?) -> Void)?

class NetWorkManager {
    //MARK:- Get Request
    class func requestGetURL(_ strURL: String,_ vc:UIViewController,_ headers : HTTPHeaders,_ completionHandler : CompletionHandler) {
        if let isInternetAvailable = NetworkReachabilityManager()?.isReachable,isInternetAvailable{
            AF.request(strURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers ).responseJSON { (responseObject) -> Void in
                switch responseObject.result {
                case .success:
                    print("Result: \(responseObject)")
                    if let jsonData = responseObject.data, jsonData.count > 0 {
                        completionHandler!(jsonData, nil)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    if let data = responseObject.data, let errStr = String(data: data, encoding: String.Encoding.utf8){
                        let error = NSError(domain: "", code: responseObject.response?.statusCode ?? 0, userInfo: [ NSLocalizedDescriptionKey: errStr])
                        completionHandler!(nil,error)
                        print("Server Error: " + errStr)
                    }else{
                        completionHandler!(nil,error)
                    }
                }
            }
        }else{
            ActivityLoader.shared().stopLoading()
            Utils.shared.showAlertMsg(Constants.alert, Constants.noInternetAvailable, vc)
        }
    }
}
