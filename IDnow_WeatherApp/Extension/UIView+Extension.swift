//
//  UIView+Extension.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 14/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit

extension UIView {
	func setAccessibility(id: String, label: String?) {
		if label != nil {
			accessibilityLabel = label
		}
		accessibilityIdentifier = id
		isAccessibilityElement = true
	}
}
