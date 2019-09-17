//
//  SavedWeather.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 18/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import Foundation

public struct SavedWeather: Codable {
	var id: Int
	var name: String
	var temp: Double
	var minTemp: Double
	var maxTemp: Double
	var condition: String
}

