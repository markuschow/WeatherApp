//
//  MainViewControllerSnapshotTests.swift
//  IDnow_WeatherAppTests
//
//  Created by Markus Chow on 17/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import FBSnapshotTestCase
@testable import IDnow_WeatherApp

class MainViewControllerSnapshotTests: SnapshotTestcase {

	var mainView: MainViewController!
	var city: City!
	var network: MockNetwork!
	
    override func setUp() {
		super.setUp()
		
        mainView = MainViewController()
		
		let coord = Coordinate(lat: 22.285521, lon: 114.157692)
		city = City(id: 1819729, name: "Hong Kong", country: "HK", coord: coord)
		
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testMainViewAtLaunch() {
		mainView.viewDidLoad()
		mainView.imageView.image = ImageStore().getImage(of: "clear_day1")
		let identifier = UIScreen.main.bounds
		FBSnapshotVerifyView(mainView.view, identifier: "\(#function)_\(identifier.width)_\(identifier.height)")

	}

	func testMainViewWithSearchBar() {
		mainView.viewDidLoad()
		mainView.imageView.image = ImageStore().getImage(of: "clear_night1")
		mainView.setupSearchController()
		let identifier = UIScreen.main.bounds
		FBSnapshotVerifyView(mainView.view, identifier: "\(#function)_\(identifier.width)_\(identifier.height)")
		
	}
	
	func testPopupWeatherInfoView() {
				
		mainView.viewDidLoad()
		mainView.imageView.image = ImageStore().getImage(of: "snow_day1")
		
		network = MockNetwork()
		network.returnCityWeather = true
		network.getCityWeather(id: city.id, units: WeatherAPI.celsius) { (weatherResponse, error) in
			if let response = weatherResponse {
				self.mainView.showPopupWeatherInfoView(city: self.city, weatherResponse: response)
			}
		}
		let identifier = UIScreen.main.bounds
		FBSnapshotVerifyView(mainView.view, identifier: "\(#function)_\(identifier.width)_\(identifier.height)")
		
	}
}
