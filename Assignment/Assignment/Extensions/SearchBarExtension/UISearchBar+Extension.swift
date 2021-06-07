//
//  UISearchBar+Extension.swift
//  Assignment
//
//  Created by Srikanth on 04/06/21.
//

import Foundation
import UIKit

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    
    func setBackgroundColor(_ color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}
