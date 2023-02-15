//
//  SearchResponse.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import Foundation
import RealmSwift

struct SearchResponse: Decodable {
    let name: String
    let state: String?
    let country: String
}

class SearchResponseToSave: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var state: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var dateCreated: Date = Date()
}
