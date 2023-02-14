//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Piotr Obara on 13/02/2023.
//

import Foundation
import UIKit

struct WeatherViewModel {
    
    let currentWeatherResponse: WeatherResponse
    var forecastWeatherResponse = [ForecastWeatherList]()
    
    var city: String {
        return currentWeatherResponse.name
    }
    
    var currentTemperature: String {
        return String(format: "%.1f°", currentWeatherResponse.main.temp)
    }
    
    var currentCondition: String {
        return currentWeatherResponse.weather[0].description
    }
    
    func numberOfRows() -> Int {
        return forecastWeatherResponse.count
    }
    
    var currentWeatherIconString: String {
        return currentWeatherResponse.weather[0].icon
    }
    
    func forecastWeatherAt(_ index: Int) -> ForecastWeatherList {
        return forecastWeatherResponse[index]
    }
}
