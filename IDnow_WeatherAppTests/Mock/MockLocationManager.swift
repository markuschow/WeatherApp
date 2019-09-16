//
//  MockLocationManager.swift
//  IDnow_WeatherAppTests
//
//  Created by Markus Chow on 16/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import Foundation
@testable import IDnow_WeatherApp

class MockLocationManager: LocationManager {

	var setupCalled = 0
	var stopCalled = 0
	
	var returnCityData = false
	var returnCityDataError = false
	var returnCityDataNilWithOutError = false
	
	var city: City!
	
	override func startUpdateLocation() {
		setupCalled += 1
	}
	
	override func stopUpdateLocation() {
		stopCalled += 1
	}
	
	override func getCityData(cities: [City], cityCoord: Coordinate, completionHandler: @escaping CityDataCompletionHandler) {
		if returnCityData {
			completionHandler(city, nil)
		}
		else if returnCityDataError {
			completionHandler(nil, .readFileError)
		}
		else if returnCityDataNilWithOutError {
			completionHandler(nil, nil)
		}
	}
}
