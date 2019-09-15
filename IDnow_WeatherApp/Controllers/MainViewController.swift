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
	
	struct ViewConfig {
		static let padding: CGFloat = 10
		static let containerViewHeight: CGFloat = 180
		static let cityLabelHeight: CGFloat = 30
		static let tempLabelHeight: CGFloat = 80
		static let minMaxTempLabelWidth: CGFloat = 80
		static let minMaxTempLabelHeight: CGFloat = 30
	}
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private lazy var containerView: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 10.0
		view.clipsToBounds = true
		return view
	}()
	
	private lazy var blurView: UIVisualEffectView = {
		let blurEffect = UIBlurEffect(style: .dark)
		let view = UIVisualEffectView(effect: blurEffect)
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 10.0
		view.clipsToBounds = true
		view.alpha = 0.6
		return view
	}()
	
	private lazy var cityLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 20)
		label.textColor = .white
		return label
	}()
	
	private lazy var tempLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 80)
		label.textColor = .white
		return label
	}()
	
	private lazy var minTempLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 20)
		label.textColor = .white
		return label
	}()
	
	private lazy var maxTempLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 20)
		label.textColor = .white
		return label
	}()
	
	private lazy var refreshButton: UIButton = {
		let button = UIButton(frame: .zero)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(refreshAction(_:)), for: .touchUpInside)
		button.setBackgroundImage(ImageStore.refreshImage(), for: .normal)
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
		
     	setupLocationManager()
		
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)


	}
	
	// MARK: - Setup
	func setupViews() {
		
		self.view.addSubview(imageView)
		self.view.addSubview(containerView)
		containerView.addSubview(blurView)
		containerView.addSubview(refreshButton)
		containerView.addSubview(cityLabel)
		containerView.addSubview(tempLabel)
		containerView.addSubview(minTempLabel)
		containerView.addSubview(maxTempLabel)

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

			containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConfig.padding),
			containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConfig.padding),
			containerView.bottomAnchor.constraint(equalTo: bottom, constant: -ViewConfig.padding),
			containerView.heightAnchor.constraint(equalToConstant: ViewConfig.containerViewHeight),

			blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			blurView.topAnchor.constraint(equalTo: containerView.topAnchor),
			blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

			refreshButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ViewConfig.padding),
			refreshButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ViewConfig.padding),
			refreshButton.widthAnchor.constraint(equalToConstant: ViewConfig.cityLabelHeight),
			refreshButton.heightAnchor.constraint(equalToConstant: ViewConfig.cityLabelHeight),

			cityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewConfig.padding),
			cityLabel.trailingAnchor.constraint(equalTo: refreshButton.leadingAnchor, constant: ViewConfig.padding),
			cityLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ViewConfig.padding),
			cityLabel.heightAnchor.constraint(equalToConstant: ViewConfig.cityLabelHeight),

			tempLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewConfig.padding),
			tempLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			tempLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -ViewConfig.padding),
			tempLabel.heightAnchor.constraint(equalToConstant: ViewConfig.tempLabelHeight),

			minTempLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewConfig.padding),
			minTempLabel.widthAnchor.constraint(equalToConstant: ViewConfig.minMaxTempLabelWidth),
			minTempLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -ViewConfig.padding),
			minTempLabel.heightAnchor.constraint(equalToConstant: ViewConfig.minMaxTempLabelHeight),

			maxTempLabel.leadingAnchor.constraint(equalTo: minTempLabel.trailingAnchor, constant: ViewConfig.padding),
			maxTempLabel.widthAnchor.constraint(equalToConstant: ViewConfig.minMaxTempLabelWidth),
			maxTempLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -ViewConfig.padding),
			maxTempLabel.heightAnchor.constraint(equalToConstant: ViewConfig.minMaxTempLabelHeight),

			])
		
	}
	
	// MARK: - Methods
	func setupLocationManager() {
		locationManager = LocationManager()
		locationManager?.delegate = self
		locationManager?.manager.startUpdatingLocation()
		locationManager?.startUpdateLocation()
	}
	
	@objc func refreshAction(_ sender: UIButton) {
		locationManager?.startUpdateLocation()
	}
	
}

extension MainViewController: LocationManagerDelegate {
	func updateCity(_ cityName: String, coord: Coordinate) {
		print("cityName: \(cityName)")
		print("coord: \(coord)")
		
		cityLabel.text = cityName
		
		locationManager?.getCityData(cityCoord: coord, completionHandler: { (city, error) in
			guard error == nil, let city = city else {
				//TODO: show error alert
				print("show error: \(String(describing: error))")
				return
			}
			
			Network.getCityWeather(id: city.id, units: weatherAPI.celsius, completionHandler: { [weak self] (response, error) in
				guard let self = self else { return }
				
				if let error = error {
					//TODO: show error alert
					print("show error: \(error)")
					return
				}
				
				if let weatherResponse = response {
					print(weatherResponse)

					self.tempLabel.text = String(Int(weatherResponse.main.temp)) + "℃"
					
					self.minTempLabel.text = "⤓" + String(Int(weatherResponse.main.temp_min)) + "℃"
					self.maxTempLabel.text = "⤒" + String(Int(weatherResponse.main.temp_max)) + "℃"
					
					if let main: String = weatherResponse.weather.first?.main {
						let randomInt = Int.random(in: 1..<4)
						let date = NSDate(timeIntervalSince1970: TimeInterval(weatherResponse.dt))
						let hour = Calendar.current.component(.hour, from: date as Date)
						let day = hour > 6 && hour < 18
						self.imageView.image = ImageStore().getImage(of: "\(main.lowercased())_\(day ? "day" : "night")\(randomInt)")
					}
					
				}
				
			})
			
		})
	}
}

public enum WeatherType: String {
	case clear
	case clouds
	case drizzle
	case rain
	case snow
	case storms
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
