//
//  MainViewControllerUITests.swift
//  IDnow_WeatherAppUITests
//
//  Created by Markus Chow on 17/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import XCTest

class MainViewControllerUITests: TestCase {

	let app = XCUIApplication()
	
    override func setUp() {
        continueAfterFailure = false

		app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testShowBackgroundImageView() {
		let element = app.maps[MainViewControllerAcessiblityIdentifier.backgroundImageIdentifier.rawValue]
		if element.waitForExistence(timeout: timeout) {
			XCTAssert(element.exists)
		}
	}
	
	func testShowSearchBar() {
		let element = app.maps[MainViewControllerAcessiblityIdentifier.searchBarIdentifier.rawValue]
		if element.waitForExistence(timeout: timeout) {
			XCTAssert(element.exists)
		}
	}
	
	func testShowWeatherInfoView() {
		var element = app.maps[MainViewControllerAcessiblityIdentifier.weatherInfoViewIdentifier.rawValue]
		if element.waitForExistence(timeout: timeout) {
			XCTAssert(element.exists)
		}
		
		element = app.maps[WeatherViewAcessiblityIdentifier.refreshButtonIdentifier.rawValue]
		if element.waitForExistence(timeout: timeout) {
			XCTAssert(element.exists)
		}
		
		element = app.maps[WeatherViewAcessiblityIdentifier.tempLabelViewIdentifier.rawValue]
		if element.waitForExistence(timeout: timeout) {
			XCTAssert(element.exists)
		}
		
		element = app.maps[WeatherViewAcessiblityIdentifier.minTempLabelViewIdentifier.rawValue]
		if element.waitForExistence(timeout: timeout) {
			XCTAssert(element.exists)
		}
		
		element = app.maps[WeatherViewAcessiblityIdentifier.maxTempLabelViewIdentifier.rawValue]
		if element.waitForExistence(timeout: timeout) {
			XCTAssert(element.exists)
		}
		
		element = app.maps[WeatherViewAcessiblityIdentifier.cityLabelIdentifier.rawValue]
		if element.waitForExistence(timeout: timeout) {
			XCTAssert(element.exists)
		}
		
		element = app.maps[WeatherViewAcessiblityIdentifier.conditionLabelIdentifier.rawValue]
		if element.waitForExistence(timeout: timeout) {
			XCTAssert(element.exists)
		}
		
	}
	
	func testWeatherInfoViewShowLoading() {
		let element = app.maps[WeatherViewAcessiblityIdentifier.loadingIdentifier.rawValue]
		if element.waitForExistence(timeout: timeout) {
			XCTAssert(element.exists)
		}

	}
	
}
