//
//  Constants.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 14/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import Foundation
import UIKit

struct WeatherAPI {
	static let appId = "0623b40d1179da5fe41624861d26ab18"
	static let cityUrl = "https://api.openweathermap.org/data/2.5/weather"
	static let forecastUrl = "http://api.openweathermap.org/data/2.5/forecast"
	static let celsius = "Metric"
	static let fahrenheit = "Imperial"
	static let distance: Double = 7000
	static let locationOffset: Double = 10
}

struct WeatherSign {
	static let celsius = "℃"
	static let minTemp = "⤓"
	static let maxTemp = "⤒"
}

struct WeatherCondition {
	static let storms = "storms"
	static let drizzle = "drizzle"
	static let rain = "rain"
	static let snow = "snow"
	static let fog = "fog"
	static let clear = "clear"
	static let clouds = "clouds"
	
}
