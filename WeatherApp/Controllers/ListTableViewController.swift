//
//  ListTableViewController.swift
//  WeatherApp
//
//  Created by Markus Chow on 17/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

	var cities: [SavedCity]?
	
	var popupWeatherInfoView: PopupWeatherInfoView?
	
	struct ViewConfig {
		static let padding: CGFloat = 10
		static let popupViewHeight: CGFloat = 250
	}
	
	private lazy var deleteAllButton: UIButton = {
		let button = UIButton(type: .custom)
		button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
		button.setBackgroundImage(ImageStore.deleteImage(), for: .normal)
		button.addTarget(self, action: #selector(deleteAll), for: .touchUpInside)
		return button
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteAllButton)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: .lightGray), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = nil
		self.navigationController?.navigationBar.isTranslucent = false

		cities = DataManager.shared.fetchCity()
		tableView.reloadData()

	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.view.backgroundColor = .clear

		super.viewWillDisappear(animated)
		
	}
	
	@objc func deleteAll() {
		DataManager.shared.deleteAllCities()
		cities?.removeAll()
		tableView.reloadData()
	}
	
	func showPopupWeatherInfoView(savedCity: SavedCity) {
		let popupView: PopupWeatherInfoView = PopupWeatherInfoView(savedCity: savedCity, delegate: self)
		popupView.transitioningDelegate = self
		popupView.modalPresentationStyle = .custom
		popupWeatherInfoView = popupView
		self.present(popupView, animated: true, completion: nil)
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cities?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: MainViewController.callIdentifier)

		if let city = cities?[indexPath.row] {
			cell.textLabel?.text = city.name
			cell.detailTextLabel?.text = String(Int(city.temp)) + WeatherSign.celsius + " - " + city.condition
		}
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
			if let city = cities?[indexPath.row] {
				DataManager.shared.deleteCity(cityId: city.id)
			}
			cities?.remove(at: indexPath.row)
			tableView.reloadData()
        }
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if let savedCity: SavedCity = cities?[indexPath.row] {
			showPopupWeatherInfoView(savedCity: savedCity)
		}
	}

}

extension ListTableViewController: PopupWeatherInfoViewDelegate {
	func savedCity(success: Bool, error: CustomSaveCityErrors?) {
		/// no implementation for this class
	}
	
	func closePopupView(completion: (() -> Void)? = nil) {
		popupWeatherInfoView?.dismiss(animated: true, completion: completion)
	}
}

extension ListTableViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
