//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Piotr Obara on 13/02/2023.
//

import Foundation
import UIKit
import RealmSwift

struct WeatherViewModel {
    
    let currentWeatherResponse: WeatherResponse
    var forecastWeatherResponse = [ForecastWeatherList]()
    let realm  = try! Realm()
    
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
    
    func checkIfWeatherSaved(searchResponse: SearchResponse) -> Bool {
        let weather = WeatherToSave()
        weather.name = searchResponse.name
        weather.state = searchResponse.state ?? ""
        weather.country = searchResponse.country
        
        var savedWeathers: Results<WeatherToSave>?
        savedWeathers = realm.objects(WeatherToSave.self)
        
        if let savedWeathers = savedWeathers {
            let result = savedWeathers.contains {
                $0.name == weather.name &&
                $0.state == weather.state &&
                $0.country == weather.country
            }
            return result
        }
        return true
    }
    
    func handleSaveUnsave(searchResponse: SearchResponse) {
        let weather = WeatherToSave()
        weather.name = searchResponse.name
        weather.state = searchResponse.state ?? ""
        weather.country = searchResponse.country
        
        var savedWeathers: Results<WeatherToSave>?
        savedWeathers = realm.objects(WeatherToSave.self)
        
        if let savedWeathers = savedWeathers {
            let result = savedWeathers.contains {
                $0.name == weather.name &&
                $0.state == weather.state &&
                $0.country == weather.country
            }
            if !result {
                saveWeather(weather)
            } else {
                removedSavedWeather(weather)
            }
        }
    }
    
    private func saveWeather(_ weather: WeatherToSave) {
        do {
            try realm.write({
                realm.add(weather)
            })
        } catch {
            print("Error saving search, \(error)")
        }
    }
    
    private func removedSavedWeather(_ weather: WeatherToSave) {
        var savedWeathers: Results<WeatherToSave>?
        savedWeathers = realm.objects(WeatherToSave.self)
        
        let weatherToRemove = savedWeathers?.filter { weatherToRemove in
            return (weatherToRemove.name == weather.name &&
                    weatherToRemove.state == weather.state &&
                    weatherToRemove.country == weather.country)
        }
        
        if let weatherToRemove = weatherToRemove {
            do {
                try realm.write({
                    realm.delete(weatherToRemove)
                })
            } catch {
                print("Error saving search, \(error)")
            }
        }
    }
}
