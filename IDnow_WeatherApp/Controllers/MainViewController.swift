//
//  MainViewController.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 14/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

	var locationManager: LocationManager?
	
	var network: Network?
	
	let searchController = UISearchController(searchResultsController: nil)
	
	var filteredCities = [City]()
	
	static let callIdentifier = "cityCell"
	
	struct ViewConfig {
		static let padding: CGFloat = 10
		static let containerViewHeight: CGFloat = 180
		static let tableViewOffset: CGFloat = 130
	}
	
	lazy var cities: [City] = {
		do {
			let path = Bundle.main.path(forResource: "citylist", ofType: "json")
			let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
			let jsonData = try JSONDecoder().decode([City].self, from: data)
			let cities: [City] = jsonData
			return cities
		} catch {
			return []
		}
	}()
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.setAccessibility(id: MainViewControllerAcessiblityIdentifier.backgroundImageIdentifier.rawValue, label: nil)
		imageView.image = ImageStore.getRandomImage(condition: "clear", timeZone: TimeZone(identifier: "UTC")!)
		return imageView
	}()

	lazy var weatherInfoView: WeatherInfoView = {
		let view = WeatherInfoView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.delegate = self
		view.layer.cornerRadius = 10.0
		view.clipsToBounds = true
		view.setAccessibility(id: MainViewControllerAcessiblityIdentifier.weatherInfoViewIdentifier.rawValue, label: nil)
		view.setupViews()
		view.applyAutolayoutConstraints()

		return view
	}()
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.setAccessibility(id: MainViewControllerAcessiblityIdentifier.tableViewViewIdentifier.rawValue, label: nil)
		tableView.layer.cornerRadius = 10.0
		tableView.dataSource = self
		tableView.delegate = self
		tableView.isHidden = true
		return tableView
	}()
	
	// MARK: - Views
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupViews()
		
		applyAutolayoutConstraints()
		
     	setupLocationManager()
		
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		refresh()
		
	}
	
	// MARK: - Setup
	func setupViews() {
	
		self.view.addSubview(imageView)
		self.view.addSubview(tableView)
		self.view.addSubview(weatherInfoView)

		setupSearchController()
	}
	
	private func applyAutolayoutConstraints() {
		let bottom: NSLayoutYAxisAnchor
		
		if #available(iOS 11.0, *) {
			bottom = view.safeAreaLayoutGuide.bottomAnchor
		} else {
			bottom = view.bottomAnchor
		}
		
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: view.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConfig.padding),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConfig.padding),
			tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: ViewConfig.tableViewOffset),
			tableView.bottomAnchor.constraint(equalTo: weatherInfoView.topAnchor, constant: -ViewConfig.padding),

			weatherInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConfig.padding),
			weatherInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConfig.padding),
			weatherInfoView.bottomAnchor.constraint(equalTo: bottom, constant: -ViewConfig.padding),
			weatherInfoView.heightAnchor.constraint(equalToConstant: ViewConfig.containerViewHeight),

			])
		
	}
	
	func setupSearchController() {
//		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search City"
		searchController.searchBar.searchBarStyle = .minimal
		searchController.searchBar.tintColor = .white
		searchController.searchBar.delegate = self
		navigationItem.searchController = searchController
		definesPresentationContext = true
		
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.view.backgroundColor = .clear
	
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
	}
	
	// MARK: - Methods
	func setupLocationManager() {
		if locationManager == nil {
			locationManager = LocationManager()
			locationManager?.delegate = self
		}
		locationManager?.startUpdateLocation()
		
	}
	
	// MARK: - Search methods
	
	func filterContentForSearchText(_ searchText: String) {
		
		self.filteredCities = self.cities.filter({( city : City) -> Bool in
			if !self.searchBarIsEmpty() {
				return city.name.lowercased().contains(searchText.lowercased())
			}
			return false
		})
		self.tableView.reloadData()
	}
	
	func searchBarIsEmpty() -> Bool {
		return self.searchController.searchBar.text?.isEmpty ?? true
	}
	
	func isFiltering() -> Bool {
		return searchController.isActive && !searchBarIsEmpty()
	}
}

extension MainViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if let text = searchController.searchBar.text {
			filterContentForSearchText(text)
		}
	}
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		filteredCities.removeAll()
		tableView.reloadData()
		tableView.isHidden = true
	}
}

extension MainViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		if let text = searchController.searchBar.text {
			filterContentForSearchText(text)
		}
	}
}

extension MainViewController: WeatherInfoViewDelegate {
	func refresh() {
		if network == nil {
			network = Network()
		}
		weatherInfoView.loadingView(show: true)
		self.setupLocationManager()
	}
}

extension MainViewController: LocationManagerDelegate {
	func updateCity(_ cityName: String, timeZone: TimeZone, coord: Coordinate) {
		print("cityName: \(cityName)")
		print("timeZone: \(timeZone)")
		print("coord: \(coord)")
		
		weatherInfoView.cityLabel.text = cityName
		
		locationManager?.getCityData(cities: cities, cityCoord: coord, completionHandler: {  [weak self] (city, error) in
			guard let self = self else { return }
			
			guard error == nil, let city = city else {
				AlertView.show(title: "Get City Error", message: nil, action: "OK", on: self)
				self.weatherInfoView.loadingView(show: false)
				return
			}
			
			self.network?.getCityWeather(id: city.id, units: WeatherAPI.celsius, completionHandler: { (response, error) in
				
				if let error = error {
					AlertView.show(title: "Get Weather Error", message: error.localizedDescription, action: "OK", on: self)
					self.weatherInfoView.loadingView(show: false)
					return
				}
				
				if let weatherResponse = response {
					print(weatherResponse)

					if let temp = weatherResponse.main?.temp {
						self.weatherInfoView.tempLabel.text = String(Int(temp)) + WeatherSign.celsius
					}
					
					if let min = weatherResponse.main?.temp_min {
						self.weatherInfoView.minTempLabel.text = WeatherSign.minTemp + String(Int(min)) + WeatherSign.celsius
					}
					
					if let max = weatherResponse.main?.temp_max {
						self.weatherInfoView.maxTempLabel.text = WeatherSign.maxTemp + String(Int(max)) + WeatherSign.celsius
					}
					
					if let id: Int = weatherResponse.weather?.first?.id, let main = weatherResponse.weather?.first?.main {
						self.weatherInfoView.conditionLabel.text = main
						let condition = ImageStore.getWeatherImageName(id: id)
						self.imageView.image = ImageStore.getRandomImage(condition: condition, timeZone: timeZone)
					}
					
				} else {
					AlertView.show(title: "Unable to show response", message: nil, action: "OK", on: self)
				}
				self.weatherInfoView.loadingView(show: false)
			})
			
		})
	}
}

extension MainViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//TODO: show city weather
		
	}
}

extension MainViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFiltering() {
			return filteredCities.count
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: MainViewController.callIdentifier)
		let city: City
		if isFiltering() {
			city = filteredCities[indexPath.row]
			cell.textLabel?.text = city.name
		}
		tableView.isHidden = (filteredCities.count == 0)
		return cell
	}
	
	
}

extension UINavigationController {
	open override var preferredStatusBarStyle: UIStatusBarStyle {
		return topViewController?.preferredStatusBarStyle ?? .lightContent
	}
}

