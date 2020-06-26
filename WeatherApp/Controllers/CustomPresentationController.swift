//
//  CustomPresentationController.swift
//  WeatherApp
//
//  Created by Markus Chow on 26.06.20.
//  Copyright © 2020 Markus Chow. All rights reserved.
//

import UIKit

class CustomPresentationController : UIPresentationController {
	override var frameOfPresentedViewInContainerView: CGRect {
		get {
			guard let theView = containerView else {
				return CGRect.zero
			}
			let offset: CGFloat = theView.bounds.height - 300
			return CGRect(x: 0, y: offset, width: theView.bounds.width, height: offset)
		}
	}
}
