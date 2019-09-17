//
//  MainViewControllerTests.swift
//  IDnow_WeatherAppTests
//
//  Created by Markus Chow on 16/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import XCTest
@testable import IDnow_WeatherApp

class MainViewControllerTests: TestCase {

	var mainView: MockMainViewController!
	var city: City!
	var locationManager: MockLocationManager!
	var network: MockNetwork!
	
    override func setUp() {
		mainView = MockMainViewController(nibName: nil, bundle: nil)
		
		let coord = Coordinate(lat: 22.285521, lon: 114.157692)
		city = City(id: 1819729, name: "Hong Kong", country: "HK", coord: coord)

		locationManager = MockLocationManager(delegate: self)
		
		network = MockNetwork()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testMainViewSetupViewShouldCalled() {
		mainView.viewDidLoad()
		XCTAssertTrue(mainView.setupViewCall > 0, "mainView setupView Should Called \(mainView.setupViewCall)")
	}
	
	func testMainViewSetupLocationManagerShouldHaveCalled() {
		mainView.viewDidLoad()
		XCTAssertTrue(mainView.setupLocationManagerCall > 0, "mainView setupLocationManager Should Called \(mainView.setupViewCall)")
	}
	
	func testRefreshShouldCallSetupLocationManager() {
		mainView.refresh()
		XCTAssertTrue(mainView.setupLocationManagerCall > 0, "mainView setupLocationManager Should Called \(mainView.setupViewCall)")
	}
	
	func testUpateCityOnSuccessShouldUpdateLabels() {
		
		locationManager.returnCityData = true
		locationManager.city = city
		
		network.returnCityWeather = true
		mainView.network = network
		
		mainView.setupViews()
		mainView.locationManager = locationManager
		let cityName = city.name
		mainView.updateCity(cityName, timeZone: TimeZone(identifier: "UTC")!, coord: Coordinate(lat: 0, lon: 0))
		
		XCTAssertTrue(self.mainView.weatherInfoView.cityLabel.text == cityName, "updateCity should return correct city name")
		XCTAssertTrue(self.mainView.weatherInfoView.tempLabel.text == "303℃", "updateCity should return correct temp")
		XCTAssertTrue(self.mainView.weatherInfoView.minTempLabel.text == "⤓302℃", "updateCity should return correct min temp")
		XCTAssertTrue(self.mainView.weatherInfoView.maxTempLabel.text == "⤒307℃", "updateCity should return correct max temp")
		XCTAssertTrue(self.mainView.weatherInfoView.conditionLabel.text == "Clouds", "updateCity should return condition")

	}
	
	func testUpateCityOnFailUpdateLabels() {

		locationManager.returnCityDataError = true
		mainView.setupViews()
		mainView.locationManager = locationManager
		let cityName = city.name

		mainView.updateCity(cityName, timeZone: TimeZone(identifier: "UTC")!, coord: Coordinate(lat: 0, lon: 0))
		
		XCTAssertTrue(self.mainView.weatherInfoView.cityLabel.text == cityName, "updateCity should return correct city name")
		XCTAssertTrue(self.mainView.weatherInfoView.tempLabel.text == nil, "updateCity should not return correct temp")
		
	}
	
}

extension MainViewControllerTests: LocationManagerDelegate {
	func updateCity(_ cityName: String, timeZone: TimeZone, coord: Coordinate) {
		
	}
	
}

