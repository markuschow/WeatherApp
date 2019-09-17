//
//  ListTableViewControllerSnapshotTests.swift
//  IDnow_WeatherAppTests
//
//  Created by Markus Chow on 18/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import FBSnapshotTestCase
@testable import IDnow_WeatherApp

class ListTableViewControllerSnapshotTests: FBSnapshotTestCase {
	
	var listView: ListTableViewController!
	var city: City!
	
	override func setUp() {
		super.setUp()
		
		listView = ListTableViewController()
		
		let coord = Coordinate(lat: 22.285521, lon: 114.157692)
		city = City(id: 1819729, name: "Hong Kong", country: "HK", coord: coord)
		
		recordMode = false
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testListViewAtLaunch() {
		listView.viewDidLoad()
		
		let identifier = UIScreen.main.bounds
		FBSnapshotVerifyView(listView.view, identifier: "\(#function)_\(identifier.width)_\(identifier.height)")
		
	}
}
