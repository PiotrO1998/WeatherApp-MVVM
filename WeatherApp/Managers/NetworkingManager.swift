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
    
    func featchWeatherByCityName(cityName: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> ()) {
        
        let urlToFetch = Constants.baseURL + "q=\(cityName)" + Constants.apiKey
        
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
        
        let urlToFetch = Constants.urlForSearch + "\(cityName)" + "&limit=10" + Constants.apiKey
        
        Session.default.request(urlToFetch, method: .get).response { response in
            debugPrint(response)
            
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
}
