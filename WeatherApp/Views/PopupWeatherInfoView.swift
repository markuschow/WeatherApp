//
//  PopupWeatherInfoView.swift
//  WeatherApp
//
//  Created by Markus Chow on 17/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit

enum CustomSaveCityErrors : String, Error, CustomStringConvertible {
    case cityAlreadySaved
	case citySaveError
	
	var description: String {
        return "\(self.rawValue)"
    }
}

protocol PopupWeatherInfoViewDelegate: class {
	func closePopupView(completion: (() -> Void)?)
	func savedCity(success: Bool, error: CustomSaveCityErrors?)
}

class PopupWeatherInfoView: UIViewController {
	
	weak var delegate: PopupWeatherInfoViewDelegate?
	
	var savedCity: SavedCity?
	
	struct ViewConfig {
		static let topPadding: CGFloat = 40
		static let padding: CGFloat = 10
		static let buttonTopPadding: CGFloat = 5
		static let buttonSize: CGFloat = 30
		static let containerViewHeight: CGFloat = 180
	}
		
	private var blurBackground: UIVisualEffectView = {
		let blurEffect = UIBlurEffect(style: .dark)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		blurEffectView.translatesAutoresizingMaskIntoConstraints = false
		return blurEffectView
	}()
	
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
	
	var saveButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setBackgroundImage(ImageStore.saveImage(), for: .normal)
		button.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
		return button
	}()
	
	init(savedCity: SavedCity, delegate: PopupWeatherInfoViewDelegate) {
		self.delegate = delegate
		self.savedCity = savedCity
		super.init(nibName: nil, bundle: nil)
		
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupViews() {
		self.view.setAccessibility(id: PopupWeatherInfoViewAcessiblityIdentifier.popupViewIdentifier.rawValue, label: nil)

		self.view.layer.cornerRadius = 10
		
		self.view.addSubview(blurBackground)
		self.view.addSubview(weatherInfoView)
		self.view.addSubview(closeButton)
		self.view.addSubview(saveButton)
		
		if let id = self.savedCity?.id {
			saveButton.isHidden = DataManager.shared.checkExists(id: id)
		} else {
			saveButton.isHidden = true
		}

		applyAutolayoutConstraints()
		
		weatherInfoView.setupViews()
		weatherInfoView.applyAutolayoutConstraints()
		
		weatherInfoView.refreshButton.isHidden = true
		
		if let savedCity = self.savedCity {
			weatherInfoView.updateContent(savedCity: savedCity)
		}
		
	}
	
	func applyAutolayoutConstraints() {
		
		NSLayoutConstraint.activate([
			
			blurBackground.topAnchor.constraint(equalTo: self.view.topAnchor),
			blurBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			blurBackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			blurBackground.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			
			weatherInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: ViewConfig.padding),
			weatherInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -ViewConfig.padding),
			weatherInfoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: ViewConfig.topPadding),
			weatherInfoView.heightAnchor.constraint(equalToConstant: ViewConfig.containerViewHeight),

			closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -ViewConfig.padding),
			closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: ViewConfig.buttonTopPadding),
			closeButton.widthAnchor.constraint(equalToConstant: ViewConfig.buttonSize),
			closeButton.heightAnchor.constraint(equalToConstant: ViewConfig.buttonSize),
			
			saveButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: ViewConfig.padding),
			saveButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: ViewConfig.buttonTopPadding),
			saveButton.widthAnchor.constraint(equalToConstant: ViewConfig.buttonSize),
			saveButton.heightAnchor.constraint(equalToConstant: ViewConfig.buttonSize),

			])
		
	}
	
	@objc func close(_ sender: UIButton) {
		delegate?.closePopupView(completion: nil)
	}
	
	@objc func save(_ sender: UIButton) {
		if let savedCity = self.savedCity {
			DataManager.shared.saveCity(savedCity: savedCity) { [weak self] reuslt in
				guard let self = self else { return }
				
				switch reuslt {
				case .success(true):
					self.delegate?.savedCity(success: true, error: nil)
				case .failure(.cityAlreadySaved):
					self.delegate?.savedCity(success: false, error: .cityAlreadySaved)
				case .failure(.citySaveError):
					fallthrough
				default:
					self.delegate?.savedCity(success: false, error: .citySaveError)
				}
				
			}
		}
	}
}
