//
//  HourlyWeatherResponse.swift
//  WeatherApp
//
//  Created by Piotr Obara on 13/02/2023.
//

import Foundation

struct ForecastWeatherResponse: Decodable {
    let list: [ForecastWeatherList]
}

 struct ForecastWeatherList: Decodable {
     let main: ForecastWeatherMain
     let weather: [ForecastWeatherData]
     let dt_txt: String
 }

struct ForecastWeatherMain: Decodable {
    
    // names need to match with json
    let temp: Double
    let feels_like: Double
    let humidity: Int
}

 struct ForecastWeatherData: Decodable {
     
     // names need to match with json
     let id: Int
     let main: String
     let description: String
     let icon: String
 }

struct Cord: Decodable {
    let lat: Double
    let lon: Double
}
 
