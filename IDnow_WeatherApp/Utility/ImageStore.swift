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

extension ImageStore {
	static func getWeatherImageName(id: Int) -> String {
		var condition = WeatherCondition.clear
		switch id {
		case 200...232:
			condition = WeatherCondition.storms
		case 300...321:
			condition = WeatherCondition.drizzle
		case 500...531:
			condition = WeatherCondition.rain
		case 600...622:
			condition = WeatherCondition.snow
		case 701...781:
			condition = WeatherCondition.fog
		case 800:
			condition = WeatherCondition.clear
		case 801...804:
			condition = WeatherCondition.clouds
		default:
			break
		}
		return condition
	}
	
	static func getRandomImage(condition: String, timeZone: TimeZone) -> UIImage {
		let randomInt = Int.random(in: 1..<4)
		var calendar = Calendar.current
		calendar.timeZone = timeZone
		let hour = calendar.component(.hour, from: Date())
		let day = hour > 6 && hour < 18
		return ImageStore().getImage(of: "\(condition)_\(day ? "day" : "night")\(randomInt)")
		
	}
}
