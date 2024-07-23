//
//  Flight.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 23/07/24.
//

import Foundation

struct Flight {
    let origin: String
    let destination: String
    let capacity: Int
    let departureDate: Date
    let returnDate: Date?
}

class FlightManager {
    static let shared = FlightManager()
    private(set) var flights: [Flight] = []
    
    private init() {}
    
    func addFlight(_ flight: Flight) {
        flights.append(flight)
    }
    
    func removeFlight(at index: Int) {
        flights.remove(at: index)
    }
}
