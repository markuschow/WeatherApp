//
//  PopupWeatherInfoView.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 17/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit

protocol PopupWeatherInfoViewDelegate: class {
	func closePopupView()
}

class PopupWeatherInfoView: UIView {
	
	weak var delegate: PopupWeatherInfoViewDelegate?
	
	struct ViewConfig {
		static let topPadding: CGFloat = 40
		static let padding: CGFloat = 10
		static let buttonTopPadding: CGFloat = 5
		static let buttonSize: CGFloat = 30
	}
	
	var weatherResponse: WeatherResponse?
	
	private var weatherInfoView: WeatherInfoView = {
		let view = WeatherInfoView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private var closeButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setBackgroundImage(ImageStore.closeImage(), for: .normal)
		button.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
		return button
	}()
	
	private var saveButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setBackgroundImage(ImageStore.saveImage(), for: .normal)
		button.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
		return button
	}()
	
	init(weatherResponse: WeatherResponse) {
		self.weatherResponse = weatherResponse
		super.init(frame: .zero)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupViews(cityName: String) {
		self.setAccessibility(id: PopupWeatherInfoViewAcessiblityIdentifier.popupViewIdentifier.rawValue, label: nil)
		self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
		self.layer.cornerRadius = 10
		
		self.addSubview(weatherInfoView)
		self.addSubview(closeButton)
		self.addSubview(saveButton)

		applyAutolayoutConstraints()
		
		weatherInfoView.setupViews()
		weatherInfoView.applyAutolayoutConstraints()
		
		weatherInfoView.cityLabel.text = cityName
		weatherInfoView.refreshButton.isHidden = true
		
		if let weather = self.weatherResponse {
			weatherInfoView.updateContent(weatherResponse: weather)
		}
		
	}
	
	func applyAutolayoutConstraints() {
		
		NSLayoutConstraint.activate([
			
			weatherInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ViewConfig.padding),
			weatherInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ViewConfig.padding),
			weatherInfoView.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewConfig.topPadding),
			weatherInfoView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -ViewConfig.padding),

			closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ViewConfig.padding),
			closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewConfig.buttonTopPadding),
			closeButton.widthAnchor.constraint(equalToConstant: ViewConfig.buttonSize),
			closeButton.heightAnchor.constraint(equalToConstant: ViewConfig.buttonSize),
			
			saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ViewConfig.padding),
			saveButton.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewConfig.buttonTopPadding),
			saveButton.widthAnchor.constraint(equalToConstant: ViewConfig.buttonSize),
			saveButton.heightAnchor.constraint(equalToConstant: ViewConfig.buttonSize),

			])
		
	}
	
	@objc func close(_ sender: UIButton) {
		delegate?.closePopupView()
	}
	
	@objc func save(_ sender: UIButton) {
		// TODO: Save city data
		
	}
}
