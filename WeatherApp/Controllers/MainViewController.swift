//
//  MainViewController.swift
//  WeatherApp
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
	
	var popupWeatherInfoView: PopupWeatherInfoView?
	
	static let callIdentifier = "cityCell"
	
	struct ViewConfig {
		static let padding: CGFloat = 10
		static let containerViewHeight: CGFloat = 180
		static let tableViewOffset: CGFloat = 130
		static let popupViewHeight: CGFloat = 250
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
	
	lazy var imageView: UIImageView = {
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
		tableView.setAccessibility(id: MainViewControllerAcessiblityIdentifier.tableViewIdentifier.rawValue, label: nil)
		tableView.layer.cornerRadius = 10.0
		tableView.dataSource = self
		tableView.delegate = self
		tableView.isHidden = true
		return tableView
	}()
	
	private lazy var listButton: UIButton = {
		let button = UIButton(type: .custom)
		button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
		button.setBackgroundImage(ImageStore.listImage(), for: .normal)
		button.addTarget(self, action: #selector(showList), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Views
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupViews()
		
		applyAutolayoutConstraints()
		
     	startLocationManager()
		
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// load city data
		if let savedWeather = DataManager.loadWeather() {
			weatherInfoView.cityLabel.text = savedWeather.name
			weatherInfoView.tempLabel.text = String(Int(savedWeather.temp)) + WeatherSign.celsius
			weatherInfoView.minTempLabel.text = WeatherSign.minTemp + String(Int(savedWeather.minTemp)) + WeatherSign.celsius
			weatherInfoView.maxTempLabel.text = WeatherSign.maxTemp + String(Int(savedWeather.maxTemp)) + WeatherSign.celsius
			weatherInfoView.conditionLabel.text = savedWeather.condition
		}
		
		refresh()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	// MARK: - Setup
	func setupViews() {
	
		self.view.addSubview(imageView)
		self.view.addSubview(tableView)
		self.view.addSubview(weatherInfoView)

		setupSearchController()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listButton)
		
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
		searchController.obscuresBackgroundDuringPresentation = false
		
		if #available(iOS 13.0, *) {
			searchController.searchBar.searchTextField.backgroundColor = .lightGray
		} else {
			searchController.searchBar.textField?.backgroundColor = .lightGray
		}
		searchController.searchBar.textField?.backgroundColor = .lightGray
		searchController.searchBar.placeholder = "Search City"
		searchController.searchBar.searchBarStyle = .minimal
		searchController.searchBar.tintColor = .white
		searchController.searchBar.delegate = self
		
		searchController.searchBar.setAccessibility(id: MainViewControllerAcessiblityIdentifier.searchBarIdentifier.rawValue, label: nil)
		
		navigationItem.searchController = searchController
		definesPresentationContext = true
		
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.view.backgroundColor = .clear
	
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
	}
	
	func showPopupWeatherInfoView(city: City, weatherResponse: WeatherResponse) {
		guard let savedCity = DataManager.getSavedCity(city: city, cityName: city.name, weatherResponse: weatherResponse) else { return }
		let popupView: PopupWeatherInfoView = PopupWeatherInfoView(savedCity: savedCity, delegate: self)
		popupView.transitioningDelegate = self
		popupView.modalPresentationStyle = .custom
		popupWeatherInfoView = popupView
		self.present(popupView, animated: true, completion: nil)
		
	}
	
	// MARK: - Methods
	func startLocationManager() {
		if locationManager == nil {
			locationManager = LocationManager(delegate: self)
		}
		locationManager?.startUpdateLocation()
	}
	
	@objc func showList() {
		let listView = ListTableViewController(style: .plain)
		self.navigationController?.pushViewController(listView, animated: true)
	}
	
	// MARK: - Search methods
	
	func filterContentForSearchText(_ searchText: String) {
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			guard let self = self else { return }

			self.filteredCities = self.cities.filter({( city : City) -> Bool in
				return city.name.lowercased().contains(searchText.lowercased())
			})

			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
		
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
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
		self.startLocationManager()
	}
}

extension MainViewController: PopupWeatherInfoViewDelegate {
	func closePopupView(completion: (() -> Void)?) {
		popupWeatherInfoView?.dismiss(animated: true, completion: completion)
	}
	
	func savedCity(success: Bool, error: CustomSaveCityErrors?) {
		closePopupView {
			if success {
				AlertView.show(title: "Saved City", message: nil, action: "OK")
			} else {
				switch error {
				case .cityAlreadySaved:
					AlertView.show(title: "City Exists", message: nil, action: "OK")
				case .citySaveError:
					fallthrough
				default:
					AlertView.show(title: "Saved City Error", message: nil, action: "OK")
				}
			}
		}
	}

}

extension MainViewController: LocationManagerDelegate {
	func updateCity(cityName: String, timeZone: TimeZone, coord: Coordinate) {
		
		weatherInfoView.cityLabel.text = cityName
		
		locationManager?.getCityData(cities: cities, cityCoord: coord, completionHandler: {  [weak self] (city, error) in
			guard let self = self else { return }
			
			guard error == nil, let city = city else {
				AlertView.show(title: "Get City Error", message: nil, action: "OK")
				self.weatherInfoView.loadingView(show: false)
				return
			}
			
			self.network?.getCityWeather(id: city.id, units: WeatherAPI.celsius, completionHandler: { (response, error) in
				
				if let error = error {
					AlertView.show(title: "Get Weather Error", message: error.localizedDescription, action: "OK")
					self.weatherInfoView.loadingView(show: false)
					return
				}
				
				if let weatherResponse = response {
					
					guard let savedCity = DataManager.getSavedCity(city: city, cityName: cityName, weatherResponse: weatherResponse) else {
						return
					}
					
					self.weatherInfoView.updateContent(savedCity: savedCity)
					
					if let id: Int = weatherResponse.weather?.first?.id {
						let condition = ImageStore.getWeatherImageName(id: id)
						self.imageView.image = ImageStore.getRandomImage(condition: condition, timeZone: timeZone)
					}
					
					// save weather data
					DataManager.saveWeather(cityId: city.id, cityName: cityName, weatherResponse: weatherResponse)
					
				} else {
					AlertView.show(title: "Unable to show response", message: nil, action: "OK")
				}
				self.weatherInfoView.loadingView(show: false)
			})
			
		})
	}
}

extension MainViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let city: City = filteredCities[indexPath.row]
		
		self.searchController.isActive = false
		self.searchBarCancelButtonClicked(searchController.searchBar)
		
		self.network?.getCityWeather(id: city.id, units: WeatherAPI.celsius, completionHandler: { (response, error) in
			if let error = error {
				AlertView.show(title: "Get Weather Error", message: error.localizedDescription, action: "OK")
				self.weatherInfoView.loadingView(show: false)
				return
			}
			if let weatherResponse = response {
				self.showPopupWeatherInfoView(city: city, weatherResponse: weatherResponse)
			} else {
				AlertView.show(title: "Unable to show response", message: nil, action: "OK")
			}
		})
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

extension MainViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

