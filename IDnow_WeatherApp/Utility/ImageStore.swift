//
//  ImageStore.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 16/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit

final class ImageStore {
	
	// image credit: https://www.pexels.com/search/weather/
	
	private struct ConfigStore {
		static let refresh: String = "refresh"
	}
	
	func getImage(of name: String) -> UIImage {
		if let image = UIImage(named: name) {
			return image
		} else {
			return UIImage()
		}
	}
	
	static func refreshImage() -> UIImage {
		return ImageStore().getImage(of: ConfigStore.refresh)
	}
	
}
