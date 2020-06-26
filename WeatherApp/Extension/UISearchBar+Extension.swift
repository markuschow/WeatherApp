//
//  UISearchBar+Extension.swift
//  WeatherApp
//
//  Created by Markus Chow on 26.06.20.
//  Copyright © 2020 Markus Chow. All rights reserved.
//

import UIKit

extension UISearchBar {

    var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        return (subViews.filter { $0 is UITextField }).first as? UITextField
    }
}
