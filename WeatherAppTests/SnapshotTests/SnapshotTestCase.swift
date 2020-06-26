//
//  SnapshotTestCase.swift
//  WeatherAppTests
//
//  Created by Markus Chow on 18/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import FBSnapshotTestCase
@testable import WeatherApp

class SnapshotTestcase: FBSnapshotTestCase {
	override func setUp() {
		super.setUp()
		
		recordMode = false
	}
}
