//
//  MockMainViewController.swift
//  WeatherAppTests
//
//  Created by Markus Chow on 16/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit
@testable import WeatherApp

class MockMainViewController: MainViewController {
	
	var setupViewCall: Int = 0
	var setupLocationManagerCall: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func setupViews() {
		super.setupViews()
		setupViewCall += 1
	}
	
	override func startLocationManager() {
		super.startLocationManager()
		setupLocationManagerCall += 1
	}
	
}

