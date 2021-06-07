//
//  ViewModelHomeScreen.swift
//  Assignment
//
//  Created by Srikanth on 04/06/21.
//

import Foundation
import UIKit
class ViewModelHomeScreen {
    //MARK:- Api Call For Countries List
    func getCountriesList(_ urlStr:String,_ vc:UIViewController,handleComplete:@escaping(Bool, Any)-> Void) {
        NetWorkManager.requestGetURL(urlStr,vc,Headers().httpHeaders()) { (result, error) in
            if let err = error{
                handleComplete(false, err)
                return
            }
            do{
                let arrModelCountriesList = try JSONDecoder().decode(Array<ModelCountriesList>.self, from: result as! Data)
                handleComplete(true, arrModelCountriesList)
            }catch{
                let modelError = try? JSONDecoder().decode(ModelError.self, from: result as! Data)
                let error = NSError(domain: "", code: 0, userInfo: [ NSLocalizedDescriptionKey: modelError?.message ?? ""])
                handleComplete(false, error)
                print("Exception")
            }
        }
    }
    //MARK:- Api Call For World Statistics
    func getWorldStatisticsList(_ urlStr:String,_ vc:UIViewController,handleComplete:@escaping(Bool, Any)-> Void) {
        NetWorkManager.requestGetURL(urlStr,vc,Headers().httpHeaders()) { (result, error) in
            if let err = error{
                handleComplete(false, err)
                return
            }
            do{
                let modelWorldStatistics = try JSONDecoder().decode(ModelWorldStatistics.self, from: result as! Data)
                handleComplete(true, modelWorldStatistics)
            }catch{
                let modelError = try? JSONDecoder().decode(ModelError.self, from: result as! Data)
                let error = NSError(domain: "", code: 0, userInfo: [ NSLocalizedDescriptionKey: modelError?.message ?? ""])
                handleComplete(false, error)
                print("Exception")
            }
        }
    }
}
