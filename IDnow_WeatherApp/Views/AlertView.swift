//
//  AlertView.swift
//  IDnow_WeatherApp
//
//  Created by Markus Chow on 16/9/2019.
//  Copyright © 2019 Markus Chow. All rights reserved.
//

import UIKit

class AlertView {
	static func show(title: String, message: String?, action: String?, on viewController: UIViewController?) {
		guard let vc = viewController else { return }
		
		let alert = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
		let action = UIAlertAction(title: action ?? "OK", style: .default, handler: nil)
		alert.addAction(action)
		alert.view.setAccessibility(id: AlertViewAcessiblityIdentifier.alertViewIdentifier.rawValue, label: nil)
		vc.present(alert, animated: true, completion: nil)
	}
}
