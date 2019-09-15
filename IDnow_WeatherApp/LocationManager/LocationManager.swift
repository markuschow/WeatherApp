//
//  LocationManager.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 15/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import Foundation
import CoreLocation

public typealias CityDataCompletionHandler = (City?, CityDataError?) -> Void

public enum CityDataError: Error {
	case readFileError
}

protocol LocationManagerDelegate: class {
	func updateCity(_ cityName: String, coord: Coordinate)
}

class LocationManager: NSObject {
	let manager: CLLocationManager
	
	let geoCoder: CLGeocoder
	
	weak var delegate: LocationManagerDelegate?
	
	override init() {
		manager = CLLocationManager()
		geoCoder = CLGeocoder()
		super.init()
		
		manager.delegate = self
		manager.distanceFilter = kCLDistanceFilterNone
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.requestWhenInUseAuthorization()
		
	}
	
	func startUpdateLocation() {
		manager.startUpdatingLocation()
	}
	
	func stopUpdateLocation() {
		manager.stopUpdatingLocation()
	}
	
	func getCityData(cityCoord: Coordinate, completionHandler: @escaping CityDataCompletionHandler) {
		
		do {
			let path = Bundle.main.path(forResource: "citylist", ofType: "json")
			let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
			let jsonData = try JSONDecoder().decode([City].self, from: data)
			let cities: [City] = jsonData
			
			if let city: City = getCity(cityCoord: cityCoord, cities: cities) {
				completionHandler(city, nil)
			} else {
				completionHandler(nil, nil)
			}
			
		} catch {
			completionHandler(nil, CityDataError.readFileError)
		}
	}
	
	func getCity(cityCoord: Coordinate, cities: [City]) -> City? {
		guard cities.count > 0 else { return nil }
		
		for city in cities {
			let coord = city.coord
			
			let cord1 = CLLocation(latitude: coord.lat, longitude: coord.lon)
			let cord2 = CLLocation(latitude: cityCoord.lat, longitude: cityCoord.lon)
			
			let distance = cord1.distance(from: cord2)
			if distance <= 7000 {
				return city
			} else if equalLocationCoordinate(location1: cord1, location2: cord2) {
				return city
			}
		}
		return nil
	}
	
	func equalLocationCoordinate(location1: CLLocation, location2: CLLocation) -> Bool {
		
		let co1Lat: Double = (location1.coordinate.latitude * 10).rounded() / 10
		let co1Lon: Double = (location1.coordinate.longitude * 10).rounded() / 10
		
		let co2Lat: Double = (location2.coordinate.latitude * 10).rounded() / 10
		let co2Lon: Double = (location2.coordinate.longitude * 10).rounded() / 10
		
		return co1Lat == co2Lat && co1Lon == co2Lon

	}
}

extension LocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.first else { return }
		
		geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
			guard let self = self else { return }
			
			if let place = placemarks?.first {
				if let city = place.locality {
					let coord = Coordinate(lat: manager.location?.coordinate.latitude ?? 0, lon: manager.location?.coordinate.longitude ?? 0)
					self.delegate?.updateCity(city, coord: coord)
				}
				self.stopUpdateLocation()
			}
		}
	}
}
