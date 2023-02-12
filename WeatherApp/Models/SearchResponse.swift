//
//  SearchResponse.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import Foundation

struct SearchResponse: Decodable {
    let name: String
    let country: String
    let state: String?
}
