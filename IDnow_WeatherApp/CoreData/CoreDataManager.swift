//
//  CoreDataManager.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 17/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
	
	static let shared = CoreDataManager()
	
	var cityData: [NSManagedObject] = []
	var weatherData: NSManagedObject?
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "IDnow_WeatherApp")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error: Error = error {
				AlertView.show(title: "Data Container Error", message: nil, action: "OK")
			}
		})
		return container
	}()
	
	func saveCity(city: City, weatherResponse: WeatherResponse) {
		let managedContext = persistentContainer.viewContext
		if let entity = NSEntityDescription.entity(forEntityName: "CityData", in: managedContext) {
			let cityData = NSManagedObject(entity: entity, insertInto: managedContext)
			
			cityData.setValue(city.id, forKeyPath: "id")
			cityData.setValue(city.name, forKeyPath: "name")
			cityData.setValue(city.country, forKeyPath: "country")
			cityData.setValue(city.coord.lat, forKeyPath: "lat")
			cityData.setValue(city.coord.lon, forKeyPath: "lon")
			
			if let temp = weatherResponse.main?.temp {
				cityData.setValue(temp, forKeyPath: "temp")
			}
			
			if let min = weatherResponse.main?.temp_min {
				cityData.setValue(min, forKeyPath: "minTemp")
			}
			
			if let max = weatherResponse.main?.temp_max {
				cityData.setValue(max, forKeyPath: "maxTemp")
			}
			
			if let condition = weatherResponse.weather?.first?.main {
				cityData.setValue(condition, forKeyPath: "condition")
			}
			
			do {
				try managedContext.save()
			} catch let error as NSError {
				print("Could not save. \(error), \(error.userInfo)")
			}
		}
	}
	
	func fetchCity() -> [SavedCity] {
		var cities = [SavedCity]()
		
		let managedContext = persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CityData")
		
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
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CityData")
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
		
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CityData")
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		
		do {
			try managedContext.execute(deleteRequest)
			try managedContext.save()
		} catch let error as NSError {
			print("Could not delete all. \(error), \(error.userInfo)")
		}
	}
	
	
}
