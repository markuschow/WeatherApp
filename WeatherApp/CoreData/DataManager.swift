//
//  DataManager.swift
//  WeatherApp
//
//  Created by Markus Chow on 17/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
	
	static let shared = DataManager()
	
	var cityData: [NSManagedObject] = []
	var weatherData: NSManagedObject?
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: DataSource.container)
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error: Error = error {
				AlertView.show(title: "Data Container Error", message: nil, action: "OK")
			}
		})
		return container
	}()
	
	func checkExists(id: Int) -> Bool {
		let managedContext = persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataSource.cityData)
		fetchRequest.predicate = NSPredicate(format: "id = %d", id)
		
		var results: [NSManagedObject] = []
		
		do {
			results = try managedContext.fetch(fetchRequest)
		} catch {
			print("error executing fetch request: \(error)")
		}
		
		return results.count > 0
	}
	
	func saveCity(savedCity: SavedCity, completionHandler: @escaping (Bool, NSError?) -> Void) {
		
		guard !checkExists(id: savedCity.id) else {
			completionHandler(false, nil)
			return
		}
		
		let managedContext = persistentContainer.viewContext
		if let entity = NSEntityDescription.entity(forEntityName: DataSource.cityData, in: managedContext) {
			let cityData = NSManagedObject(entity: entity, insertInto: managedContext)
			
			cityData.setValue(savedCity.id, forKeyPath: "id")
			cityData.setValue(savedCity.name, forKeyPath: "name")
			cityData.setValue(savedCity.country, forKeyPath: "country")
			cityData.setValue(savedCity.lat, forKeyPath: "lat")
			cityData.setValue(savedCity.lon, forKeyPath: "lon")
			
			cityData.setValue(savedCity.temp, forKeyPath: "temp")
			cityData.setValue(savedCity.minTemp, forKeyPath: "minTemp")
			cityData.setValue(savedCity.maxTemp, forKeyPath: "maxTemp")
			cityData.setValue(savedCity.condition, forKeyPath: "condition")
			
			do {
				try managedContext.save()
				completionHandler(true, nil)
			} catch let error as NSError {
				print("Could not save. \(error), \(error.userInfo)")
				completionHandler(false, error)
			}
		}
	}
	
	func fetchCity() -> [SavedCity] {
		var cities = [SavedCity]()
		
		let managedContext = persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataSource.cityData)
		
		do {
			cityData = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
		
		for savedCity in cityData {
			if let id = savedCity.value(forKey: "id") as? Int,
				let name = savedCity.value(forKey: "name") as? String,
				let country = savedCity.value(forKey: "country") as? String,
				let lat = savedCity.value(forKey: "lat") as? Double,
				let lon = savedCity.value(forKey: "lon") as? Double,
				let temp = savedCity.value(forKey: "temp") as? Double,
				let minTemp = savedCity.value(forKey: "minTemp") as? Double,
				let maxTemp = savedCity.value(forKey: "maxTemp") as? Double,
				let condition = savedCity.value(forKey: "condition") as? String {
				
				let city = SavedCity(id: id, name: name, country: country, lat: lat, lon: lon, temp: temp, minTemp: minTemp, maxTemp: maxTemp, condition: condition)
				cities.append(city)
			}
		}
		
		return cities
	}
	
	func deleteCity(cityId: Int){
		
		let managedContext = persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DataSource.cityData)
		fetchRequest.predicate = NSPredicate(format: "id = %d", cityId)
		
		do {
			
			let remove = try managedContext.fetch(fetchRequest)
			
			if let objectToDelete = remove[0] as? NSManagedObject {
				managedContext.delete(objectToDelete)
			}
			try managedContext.save()
		} catch let error as NSError {
			print("Could not delete. \(error), \(error.userInfo)")
		}
	}
	
	func deleteAllCities() {
		
		let managedContext = persistentContainer.viewContext
		
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DataSource.cityData)
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		
		do {
			try managedContext.execute(deleteRequest)
			try managedContext.save()
		} catch let error as NSError {
			print("Could not delete all. \(error), \(error.userInfo)")
		}
	}
	
	static func saveWeather(cityId: Int, cityName: String, weatherResponse: WeatherResponse) {
		if let temp = weatherResponse.main?.temp,
			let min = weatherResponse.main?.temp_min,
			let max = weatherResponse.main?.temp_max,
			let condition = weatherResponse.weather?.first?.main {
			
			let savedWeather = SavedWeather(id: cityId, name: cityName, temp: temp, minTemp: min, maxTemp: max, condition: condition)
			
			if let savedWeather = try? JSONEncoder().encode(savedWeather) {
				UserDefaults.standard.set(savedWeather, forKey: Save.weather)
			}
		}
	}
	
	static func loadWeather() -> SavedWeather? {
		if let savedWeather = UserDefaults.standard.object(forKey: Save.weather) as? Data {
			if let loadedWeather = try? JSONDecoder().decode(SavedWeather.self, from: savedWeather) {
				return loadedWeather
			}
		}
		return nil
	}

	static func getSavedCity(city: City, cityName: String, weatherResponse: WeatherResponse) -> SavedCity? {
		if let temp = weatherResponse.main?.temp,
			let min = weatherResponse.main?.temp_min,
			let max = weatherResponse.main?.temp_max,
			let condition = weatherResponse.weather?.first?.main {
			
			let savedCity = SavedCity(id: city.id, name: cityName, country: city.country,
									  lat: city.coord.lat, lon: city.coord.lon,
									  temp: temp, minTemp: min, maxTemp: max, condition: condition)
			
			return savedCity
			
		}
		return nil
	}
}
