//
//  NetworkingManager.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case decodingError
    case invalidData
}

final class NetworkingManager {
    static let shared = NetworkingManager()
    
    private init() {}
    
    //
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
            case .failure(_):
                completion(.failure(.invalidData))
            }
        }
    }
    
    func searchForCity(cityName: String, completition: @escaping ([String]) -> ()) {
        
    }
    
    
}
