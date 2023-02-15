//
//  ViewControllerExtension.swift
//  WeatherApp
//
//  Created by Piotr Obara on 15/02/2023.
//

import UIKit

extension UIViewController {
    func showOkAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
