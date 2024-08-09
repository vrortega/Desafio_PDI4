//
//  API.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 30/07/24.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let name: String
    let region: String
}

struct Current: Codable {
    let temp_c: Double
    let wind_kph: Double
    let humidity: Int
}

