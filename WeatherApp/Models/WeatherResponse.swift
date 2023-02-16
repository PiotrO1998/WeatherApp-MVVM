//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import Foundation

struct WeatherResponse: Decodable {
    let id: Int
    let weather: [WeatherData]
    let main: WeatherMain
    let name: String
}

struct WeatherData: Decodable {
    
    // names need to match with json
    let id: Int
    let description: String
    let icon: String
}

struct WeatherMain: Decodable {
    
    // names need to match with json
    let temp: Double
    let feels_like: Double
    let humidity: Int
}
