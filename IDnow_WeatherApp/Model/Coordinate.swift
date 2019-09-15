
//
//  Coordinate.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 15/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import Foundation

public struct Coordinate: Decodable {
	
	let lat: Double
	let lon: Double
	
	enum CodingKeys: String, CodingKey {
		case lat
		case lon
	}
}
