//
//  ActivityLoader.swift
//  Assignment
//
//  Created by Srikanth on 04/06/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class ActivityLoader:UIViewController,NVActivityIndicatorViewable{
    
    class func shared() -> ActivityLoader {
        struct Static {
            static let manager = ActivityLoader()
        }
        return Static.manager
    }
    //MARK:- Start Loading
    func startLoading(){
        startAnimating(CGSize(width:50, height: 50),message:Constants.loading,
                       type:.ballPulseSync,backgroundColor: UIColor.gray )
    }
    //MARK:- Stop Loading
    func stopLoading(){
        stopAnimating()
    }
}
