//
//  WeatherInfoView.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 16/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit

protocol WeatherInfoViewDelegate: class {
	func refresh()
}

class WeatherInfoView: UIView {

	weak var delegate: WeatherInfoViewDelegate?	
	
	struct ViewConfig {
		static let padding: CGFloat = 10
		static let cityLabelHeight: CGFloat = 30
		static let tempLabelHeight: CGFloat = 80
		static let minMaxTempLabelWidth: CGFloat = 80
		static let minMaxTempLabelHeight: CGFloat = 30
	}
	
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
	
	lazy var cityLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 20)
		label.textColor = .white
		label.setAccessibility(id: WeatherViewAcessiblityIdentifier.cityLabelIdentifier.rawValue, label: label.text)
		return label
	}()
	
	lazy var tempLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 80)
		label.textColor = .white
		label.setAccessibility(id: WeatherViewAcessiblityIdentifier.tempLabelViewIdentifier.rawValue, label: label.text)
		return label
	}()
	
	lazy var minTempLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 20)
		label.textColor = .white
		label.setAccessibility(id: WeatherViewAcessiblityIdentifier.minTempLabelViewIdentifier.rawValue, label: label.text)
		return label
	}()
	
	lazy var maxTempLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 20)
		label.textColor = .white
		label.setAccessibility(id: WeatherViewAcessiblityIdentifier.maxTempLabelViewIdentifier.rawValue, label: label.text)
		return label
	}()
	
	lazy var conditionLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 20)
		label.minimumScaleFactor = 0.2
		label.textColor = .white
		label.setAccessibility(id: WeatherViewAcessiblityIdentifier.conditionLabelIdentifier.rawValue, label: label.text)
		return label
	}()
	
	lazy var refreshButton: UIButton = {
		let button = UIButton(frame: .zero)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(refreshAction(_:)), for: .touchUpInside)
		button.setBackgroundImage(ImageStore.refreshImage(), for: .normal)
		button.setAccessibility(id: WeatherViewAcessiblityIdentifier.refreshButtonIdentifier.rawValue, label: "refresh")
		return button
	}()
	
	private lazy var loadingView: UIActivityIndicatorView = {
		let loadingView = UIActivityIndicatorView(style: .whiteLarge)
		loadingView.translatesAutoresizingMaskIntoConstraints = false
		loadingView.hidesWhenStopped = true
		loadingView.setAccessibility(id: WeatherViewAcessiblityIdentifier.loadingIdentifier.rawValue, label: "loading")
		return loadingView
	}()
	
	func setupViews() {
		
		self.addSubview(blurView)
		self.addSubview(refreshButton)
		self.addSubview(cityLabel)
		self.addSubview(tempLabel)
		self.addSubview(minTempLabel)
		self.addSubview(maxTempLabel)
		self.addSubview(conditionLabel)
		self.addSubview(loadingView)
		
	}

	func applyAutolayoutConstraints() {
		
		NSLayoutConstraint.activate([
			
			blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			blurView.topAnchor.constraint(equalTo: self.topAnchor),
			blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			
			refreshButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ViewConfig.padding),
			refreshButton.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewConfig.padding),
			refreshButton.widthAnchor.constraint(equalToConstant: ViewConfig.cityLabelHeight),
			refreshButton.heightAnchor.constraint(equalToConstant: ViewConfig.cityLabelHeight),
			
			cityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ViewConfig.padding),
			cityLabel.trailingAnchor.constraint(equalTo: refreshButton.leadingAnchor, constant: ViewConfig.padding),
			cityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewConfig.padding),
			cityLabel.heightAnchor.constraint(equalToConstant: ViewConfig.cityLabelHeight),
			
			tempLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ViewConfig.padding),
			tempLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			tempLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -ViewConfig.padding),
			tempLabel.heightAnchor.constraint(equalToConstant: ViewConfig.tempLabelHeight),
			
			minTempLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ViewConfig.padding),
			minTempLabel.widthAnchor.constraint(equalToConstant: ViewConfig.minMaxTempLabelWidth),
			minTempLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -ViewConfig.padding),
			minTempLabel.heightAnchor.constraint(equalToConstant: ViewConfig.minMaxTempLabelHeight),
			
			maxTempLabel.leadingAnchor.constraint(equalTo: minTempLabel.trailingAnchor, constant: ViewConfig.padding),
			maxTempLabel.widthAnchor.constraint(equalToConstant: ViewConfig.minMaxTempLabelWidth),
			maxTempLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -ViewConfig.padding),
			maxTempLabel.heightAnchor.constraint(equalToConstant: ViewConfig.minMaxTempLabelHeight),
			
			conditionLabel.leadingAnchor.constraint(equalTo: maxTempLabel.trailingAnchor, constant: ViewConfig.padding),
			conditionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ViewConfig.padding),
			conditionLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -ViewConfig.padding),
			conditionLabel.heightAnchor.constraint(equalToConstant: ViewConfig.minMaxTempLabelHeight),
			
			loadingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ViewConfig.padding),
			loadingView.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewConfig.padding),
			loadingView.widthAnchor.constraint(equalToConstant: ViewConfig.cityLabelHeight),
			loadingView.heightAnchor.constraint(equalToConstant: ViewConfig.cityLabelHeight),
			
			])
		
	}
	
	@objc func refreshAction(_ sender: UIButton) {
		delegate?.refresh()		
	}
	
	func loadingView(show: Bool) {
		refreshButton.isHidden = show
		loadingView.isHidden = !show
		if show {
			loadingView.startAnimating()
		} else {
			loadingView.stopAnimating()
		}
	}
	
	func updateContent(weatherResponse: WeatherResponse) {
		
		if let temp = weatherResponse.main?.temp {
			self.tempLabel.text = String(Int(temp)) + WeatherSign.celsius
		}
		
		if let min = weatherResponse.main?.temp_min {
			self.minTempLabel.text = WeatherSign.minTemp + String(Int(min)) + WeatherSign.celsius
		}
		
		if let max = weatherResponse.main?.temp_max {
			self.maxTempLabel.text = WeatherSign.maxTemp + String(Int(max)) + WeatherSign.celsius
		}
		
		if let main = weatherResponse.weather?.first?.main {
			self.conditionLabel.text = main
		}
	}
}
