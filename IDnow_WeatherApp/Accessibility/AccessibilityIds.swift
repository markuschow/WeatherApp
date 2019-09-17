//
//  AccessibilityIds.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 16/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import Foundation

enum MainViewControllerAcessiblityIdentifier: String {
	case backgroundImageIdentifier = "mainView.backgroundImage"
	case resultsTableViewIdentifier = "mainView.resultsTableView"
	case weatherInfoViewIdentifier = "mainView.weatherInfoView"
	case tableViewIdentifier = "mainView.tableView"
	case searchBarIdentifier = "mainView.searchBar"
}

enum WeatherViewAcessiblityIdentifier: String {
	case refreshButtonIdentifier = "weatherView.refreshButton"
	case tempLabelViewIdentifier = "weatherView.tempLabel"
	case minTempLabelViewIdentifier = "weatherView.minTempLabel"
	case maxTempLabelViewIdentifier = "weatherView.maxTempLabel"
	case cityLabelIdentifier = "weatherView.cityLabel"
	case conditionLabelIdentifier = "weatherView.conditionLabel"
	case loadingIdentifier = "weatherView.loading"
}

enum WeatherListControllerAcessiblityIdentifier: String {
	case tableViewIdentifier = "weatherList.tableView"
	case weatherCellIdentifier = "weatherList.weatherCell"
	case deleteButtonIdentifier = "weatherList.deleteButton"
}

enum AlertViewAcessiblityIdentifier: String {
	case alertViewIdentifier = "alertView"
}
