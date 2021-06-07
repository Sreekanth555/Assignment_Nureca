//
//  ViewModelStatistics.swift
//  Assignment
//
//  Created by Srikanth on 05/06/21.
//

import Foundation
import UIKit
class ViewModelStatistics {
    //MARK:- Api Call For Country Statistics List
    func getCountriesStatisticsList(_ urlStr:String,_ vc:UIViewController,handleComplete:@escaping(Bool, Any)-> Void) {
        NetWorkManager.requestGetURL(urlStr,vc, Headers().httpHeaders()) { (result, error) in
            if let err = error{
                handleComplete(false, err)
                return
            }
            do{
                let arrModelCountriesStatistics = try JSONDecoder().decode(Array<ModelCountriesStatistics>.self, from: result as! Data)
                handleComplete(true, arrModelCountriesStatistics)
            }catch{
                let modelError = try? JSONDecoder().decode(ModelError.self, from: result as! Data)
                let error = NSError(domain: "", code: 0, userInfo: [ NSLocalizedDescriptionKey: modelError?.message ?? ""])
                handleComplete(false, error)
                print("Exception")
            }
        }
    }
}
