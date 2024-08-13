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
    let departureDate: String
    let returnDate: String?
    let pilots: [Pilot]
    let coPilots: [CoPilot]
    let flightAttendants: [FlightAttendant]
    let passengers: [Passenger]
}

