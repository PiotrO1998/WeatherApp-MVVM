//
//  WeatherToSave.swift
//  WeatherApp
//
//  Created by Piotr Obara on 15/02/2023.
//

import Foundation

import Foundation
import RealmSwift

class WeatherToSave: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var state: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var dateCreated: Date = Date()
}
