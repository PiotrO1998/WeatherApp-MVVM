//
//  NetworkingManager.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

enum NetworkError: Error {
    case decodingError
    case invalidData
}

final class NetworkingManager {
    static let shared = NetworkingManager()
    
    private init() {}
    
    func fetchWeather(cityName: String, stateCode: String?, countryCode: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> ()) {
        
        var fetchWeatherWith = ""
        if let stateCode = stateCode {
            fetchWeatherWith = "q=\(cityName.escaped()),\(stateCode.escaped()),\(countryCode.escaped())"
        } else {
            fetchWeatherWith = "q=\(cityName.escaped()),\(countryCode.escaped())"
        }
        
        let urlToFetch = Constants.Urls.baseURL + fetchWeatherWith + Constants.Urls.apiKey + "&units=metric"
        
        Session.default.request(urlToFetch, method: .get).response { response in
            //debugPrint(response)
            
            switch response.result {
            case let .success(data):
                let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data!)
                
                if let weatherResponse = weatherResponse {
                    completion(.success(weatherResponse))
                } else {
                    completion(.failure(.decodingError))
                }
            case let .failure(error):
                print(error)
                completion(.failure(.invalidData))
            }
        }
    }
    
    func searchForCities(with cityName: String, completion: @escaping ([SearchResponse]) -> ()) {
        
        let urlToFetch = Constants.Urls.urlForSearch + "q=\(cityName.escaped())" + "&limit=10" + Constants.Urls.apiKey
        
        Session.default.request(urlToFetch, method: .get).response { response in
            //debugPrint(response)
            
            switch response.result {
            case let .success(data):
                let response = try? JSONDecoder().decode([SearchResponse].self, from: data!)
                if let response = response {
                    completion(response)
                } else {
                    completion([])
                }
            case let .failure(error):
                print(error)
                completion([])
            }
        }
    }
    
    func fetchForecastWeather(cityName: String, stateCode: String?, countryCode: String, completion: @escaping (Result<ForecastWeatherResponse, NetworkError>) -> ()) {
        
        var fetchWeatherWith = ""
        if let stateCode = stateCode {
            fetchWeatherWith = "q=\(cityName.escaped()),\(stateCode.escaped()),\(countryCode.escaped())"
        } else {
            fetchWeatherWith = "q=\(cityName.escaped()),\(countryCode.escaped())"
        }
        
        let urlToFetch = Constants.Urls.urlHourly + fetchWeatherWith + Constants.Urls.apiKey + "&cnt=8&units=metric"
        
        Session.default.request(urlToFetch, method: .get).response { response in
            //debugPrint(response)
            
            switch response.result {
            case let .success(data):
                let weatherResponse = try? JSONDecoder().decode(ForecastWeatherResponse.self, from: data!)
                
                if let weatherResponse = weatherResponse {
                    completion(.success(weatherResponse))
                } else {
                    completion(.failure(.decodingError))
                }
            case let .failure(error):
                print(error)
                completion(.failure(.invalidData))
            }
        }
    }
    
    func getIconImage(iconCode: String, completion: @escaping (Data?) -> ()) {
        
        let urlToFetch = Constants.Urls.getIconUrl(conditionCode: iconCode)
        
        
        Session.default.request(urlToFetch, method: .get).response { response in
            //debugPrint(response)
            
            switch response.result {
            case let .success(data):
                completion(data)
            case let .failure(error):
                print(error)
                completion(nil)
            }
            
        }
    }
}

private extension String {
    func escaped() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}
