//
//  SavedWeathersViewController.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import UIKit

class SavedWeathersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weathers"
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        NetworkingManager.shared.featchWeatherByCityName(cityName: "Kielce") { weather in
            //print(weather)
        }
        
        NetworkingManager.shared.searchForCities(cityName: "Vienna") { names in
            for name in names {
                print(name)
            }
        }
    }
}
