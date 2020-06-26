//
//  Network.swift
//  WeatherApp
//
//  Created by Markus Chow on 15/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkError: Error {
	case requestError
	case dateParseError
	case invalidPath
	case parseError
}

class Network {
	func getCityWeather(id: Int, units: String, completionHandler: @escaping (WeatherResponse?, NetworkError?) -> Void) {
		let parameters: [String: String] = [
			"id": String(id),
			"appid": WeatherAPI.appId,
			"units": units,
		]
		
		AF.request(WeatherAPI.cityUrl, method: .get, parameters: parameters).responseDecodable(of: WeatherResponse.self) { response in
			if (response.error != nil) {
				completionHandler(nil, .requestError)
			} else {
				completionHandler(response.value, nil)
			}			
		}
		

	}
	
}
