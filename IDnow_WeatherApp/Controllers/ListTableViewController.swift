//
//  ListTableViewController.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 17/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

	var cities: [SavedCity]?
	
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
		
		self.navigationController?.navigationBar.shadowImage = nil
		self.navigationController?.navigationBar.isTranslucent = false

		cities = CoreDataManager.shared.fetchCity()
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
		CoreDataManager.shared.deleteAllCities()
		cities?.removeAll()
		tableView.reloadData()
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cities?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: MainViewController.callIdentifier)

		if let city = cities?[indexPath.row] {
			cell.textLabel?.text = city.name
			cell.detailTextLabel?.text = String(Int(city.temp)) + WeatherSign.celsius
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
				CoreDataManager.shared.deleteCity(cityId: city.id)
			}
			cities?.remove(at: indexPath.row)
			tableView.reloadData()
        }
    }

}
