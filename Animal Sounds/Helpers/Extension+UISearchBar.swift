//
//  Extension+UISearchBar.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 4.10.2024.
//

import UIKit

//????? Kalsin simdilik
extension UISearchBar {
    func setTextFieldColor(_ color: UIColor) {
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = color
        }
    }
}
