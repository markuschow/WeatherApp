//
//  City.swift
//  WeatherApp
//
//  Created by Markus Chow on 15/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import Foundation

public struct City: Decodable {
	let id: Int
	let name: String
	let country: String
	let coord: Coordinate

	enum CodingKeys: String, CodingKey  {
		case id
		case name
		case country
		case coord
	}
}
