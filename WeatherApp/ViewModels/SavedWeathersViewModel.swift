//
//  SavedWeatherViewModel.swift
//  WeatherApp
//
//  Created by Piotr Obara on 14/02/2023.
//

import Foundation

class SavedWeathersViewModel {
    private(set) var savedWeathersViewModel = [SavedWeatherViewModel]()
    
    func addSavedWeatherViewModel(_ vm: SavedWeatherViewModel) {
        savedWeathersViewModel.append(vm)
    }
    
    func numberOfRows() -> Int {
        return savedWeathersViewModel.count
    }
    
    func modelAt(_ index: Int) -> SavedWeatherViewModel {
        return savedWeathersViewModel[index]
    }
    
    func removeViewModels() {
        savedWeathersViewModel = [SavedWeatherViewModel]()
    }
}


class SavedWeatherViewModel {
    private let weather: WeatherResponse
    let searchResponse: SearchResponse
    
    init(weather: WeatherResponse, searchResponse: SearchResponse) {
        self.weather = weather
        self.searchResponse = searchResponse
    }
    
    var city: String {
        return weather.name
    }
    
    var temperature: String {
        return String(format: "%.1f°", weather.main.temp)
    }
    
    var condition: String {
        return weather.weather[0].description
    }
    
    var iconString: String {
        return weather.weather[0].icon
    }
}
