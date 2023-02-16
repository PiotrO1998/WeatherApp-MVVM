//
//  SavedWeatherViewModel.swift
//  WeatherApp
//
//  Created by Piotr Obara on 14/02/2023.
//

import Foundation
import RealmSwift

class SavedWeathersViewModel {
    private(set) var savedWeathersViewModel = [SavedWeatherViewModel]()
    let realm  = try! Realm()
    
    func addSavedWeatherViewModel(_ vm: SavedWeatherViewModel) {
        savedWeathersViewModel.append(vm)
        saveWeatherToRealm(weatherViewModel: vm)
    }
    
    func removeSavedWeatherViewModel(at index: Int) {
        removeWeatherFromRealm(id: savedWeathersViewModel[index].id)
        savedWeathersViewModel.remove(at: index)
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
    
    private func saveWeatherToRealm(weatherViewModel: SavedWeatherViewModel) {
        let weatherSaved = Constants.checkIfWeatherSaved(id: weatherViewModel.id)
        
        if weatherSaved {
            return
        }
        
        let weather = WeatherToSave()
        weather.id = "\(weatherViewModel.id)"
        weather.name = weatherViewModel.searchResponse.name
        weather.state = weatherViewModel.searchResponse.state ?? ""
        weather.country = weatherViewModel.searchResponse.country
        
        do {
            try realm.write({
                realm.add(weather)
            })
        } catch {
            print("Error saving search, \(error)")
        }
    }
    
    private func removeWeatherFromRealm(id: Int) {
        let weatherSaved = Constants.checkIfWeatherSaved(id: id)
        
        if !weatherSaved {
            return
        }
        
        var savedWeathers: Results<WeatherToSave>?
        savedWeathers = realm.objects(WeatherToSave.self)
        
        let weatherToRemove = savedWeathers?.filter {
            $0.id == "\(id)"
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


class SavedWeatherViewModel {
    private let weather: WeatherResponse
    let searchResponse: SearchResponse
    
    init(weather: WeatherResponse, searchResponse: SearchResponse) {
        self.weather = weather
        self.searchResponse = searchResponse
    }
    
    var name: String {
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
    
    var id: Int {
        return weather.id
    }
}
