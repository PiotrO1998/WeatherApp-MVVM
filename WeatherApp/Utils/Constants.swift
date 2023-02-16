//
//  Constants.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import Foundation
import RealmSwift

struct Constants {
    
    static func getConditionImageName(conditionId: Int) -> String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    static func stringToTime(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = dateFormatter.date(from: dateString)
        
        let dateFormatterTwo = DateFormatter()
        dateFormatterTwo.dateFormat = "HH:mm"
        return dateFormatterTwo.string(from: date!)
    }
    
    static func checkIfWeatherSaved(id: Int) -> Bool {
        let realm  = try! Realm()
        
        var savedWeathers: Results<WeatherToSave>?
        savedWeathers = realm.objects(WeatherToSave.self)
        
        if let savedWeathers = savedWeathers {
            let result = savedWeathers.contains {
                $0.id == "\(id)"
            }
            return result
        }
        return true
    }
    
    struct Urls {
        static let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
        static let urlForSearch = "https://api.openweathermap.org/geo/1.0/direct?"
        static let urlHourly = "https://api.openweathermap.org/data/2.5/forecast?"
        static let apiKey = "&appid=1e58d907e3bc6d295b3d3977add99d49"
        
        static func getIconUrl(conditionCode: String) -> String {
            let url = "https://openweathermap.org/img/wn/\(conditionCode)@2x.png"
            return url
        }
    } 
}
