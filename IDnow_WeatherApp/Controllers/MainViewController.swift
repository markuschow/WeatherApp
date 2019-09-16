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
	
	struct ViewConfig {
		static let padding: CGFloat = 10
		static let containerViewHeight: CGFloat = 180
	}
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.setAccessibility(id: MainViewControllerAcessiblityIdentifier.backgroundImageIdentifier.rawValue, label: nil)
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
		self.view.addSubview(weatherInfoView)
		
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

			weatherInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConfig.padding),
			weatherInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConfig.padding),
			weatherInfoView.bottomAnchor.constraint(equalTo: bottom, constant: -ViewConfig.padding),
			weatherInfoView.heightAnchor.constraint(equalToConstant: ViewConfig.containerViewHeight),

			])
		
	}
	
	// MARK: - Methods
	func setupLocationManager() {
		if locationManager == nil {
			locationManager = LocationManager()
			locationManager?.delegate = self
		}
		locationManager?.startUpdateLocation()
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
		
		locationManager?.getCityData(cityCoord: coord, completionHandler: {  [weak self] (city, error) in
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

					self.weatherInfoView.tempLabel.text = String(Int(weatherResponse.main.temp)) + WeatherSign.celsius
					self.weatherInfoView.minTempLabel.text = WeatherSign.minTemp + String(Int(weatherResponse.main.temp_min)) + WeatherSign.celsius
					self.weatherInfoView.maxTempLabel.text = WeatherSign.maxTemp + String(Int(weatherResponse.main.temp_max)) + WeatherSign.celsius
					
					if let id: Int = weatherResponse.weather.first?.id, let main = weatherResponse.weather.first?.main {
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
	
}

extension MainViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
	
}
