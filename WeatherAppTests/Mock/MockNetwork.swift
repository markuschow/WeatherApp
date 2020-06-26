//
//  MockNetwork.swift
//  WeatherAppTests
//
//  Created by Markus Chow on 17/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import Foundation
@testable import WeatherApp

class MockNetwork: Network {
	
	var returnCityWeather = false
	var returnNetworkError = false
	var returnCityWeatherNilWithOutError = false

	override func getCityWeather(id: Int, units: String, completionHandler: @escaping (WeatherResponse?, NetworkError?) -> Void) {
		if returnNetworkError {
			completionHandler(nil, .requestError)
			return
		}
		
		do {
			let path = Bundle.main.path(forResource: "weather", ofType: "json")
			let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
			let jsonData = try JSONDecoder().decode(WeatherResponse.self, from: data)
			completionHandler(jsonData, nil)
		} catch {
			completionHandler(nil, .dateParseError)
		}
	}
}
