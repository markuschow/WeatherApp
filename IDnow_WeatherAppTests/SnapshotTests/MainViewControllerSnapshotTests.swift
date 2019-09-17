//
//  MainViewControllerSnapshotTests.swift
//  IDnow_WeatherAppTests
//
//  Created by Markus Chow on 17/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import FBSnapshotTestCase
@testable import IDnow_WeatherApp

class MainViewControllerSnapshotTests: FBSnapshotTestCase {

	var mainView: MainViewController!
	
    override func setUp() {
		super.setUp()
		
        mainView = MainViewController()
		
		recordMode = false
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
}
