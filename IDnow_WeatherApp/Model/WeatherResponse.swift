//
//  WeatherResponse.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 15/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import Foundation

public struct WeatherResponse: Decodable {
	let coord: Coordinate?
	let weather: [Weather]?
	let base: String?
	let main: Main?
	let visibility: Int?
	let wind: Wind?
	let clouds: Clouds?
	let dt: Int?
	let sys: Sys?
	let timezone: Int?
	let id: Int?
	let name: String?
	let cod: Int?
	
	enum CodingKeys: String, CodingKey  {
		case coord
		case weather
		case base
		case main
		case visibility
		case wind
		case clouds
		case dt
		case sys
		case timezone
		case id
		case name
		case cod
		
	}
}

public struct Weather: Decodable {
	let id: Int?
	let main: String?
	let description: String?
	let icon: String?
	
	enum CodingKeys: String, CodingKey  {
		case id
		case main
		case description
		case icon
	}
}

public struct Main: Decodable {
	let temp: Double?
	let pressure: Int?
	let humidity: Int?
	let temp_min: Double?
	let temp_max: Double?
	
	enum CodingKeys: String, CodingKey  {
		case temp
		case pressure
		case humidity
		case temp_min
		case temp_max
	}
}

public struct Wind: Decodable {
	let speed: Double?
	let deg: Double?
	
	enum CodingKeys: String, CodingKey  {
		case speed
		case deg
	}
}

public struct Clouds: Decodable {
	let all: Int?
	
	enum CodingKeys: String, CodingKey  {
		case all
	}
}

public struct Sys: Decodable {
	let type: Int?
	let id: Int?
	let message: Double?
	let country: String?
	let sunrise: Int?
	let sunset: Int?
	
	enum CodingKeys: String, CodingKey  {
		case type
		case id
		case message
		case country
		case sunrise
		case sunset
	}
}
