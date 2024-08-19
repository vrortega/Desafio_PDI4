//
//  FlightDetailsViewModel.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 17/10/24.
//

import Foundation

class FlightDetailsViewModel {
    var flight: Flight

    var origin: String {
        return flight.origin
    }

    var destination: String {
        return flight.destination
    }

    var departureDateText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let departureDate = dateFormatter.date(from: flight.departureDate) ?? Date()
        return "Ida: \(dateFormatter.string(from: departureDate))"
    }

    var returnDateText: String {
        guard let returnDate = flight.returnDate else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let date = dateFormatter.date(from: returnDate) ?? Date()
        return "Volta: \(dateFormatter.string(from: date))"
    }

    var passengersLabelText: String {
        return "Passageiros | Capacidade: \(flight.capacity)"
    }

    var passengerNames: [String] {
        return flight.passengers.map { $0.name }
    }

    var crewInfo: [String] {
        var crewDetails = [String]()
        flight.pilots.forEach { crewDetails.append("Piloto: \($0.name)") }
        flight.coPilots.forEach { crewDetails.append("Co-Piloto: \($0.name)") }
        flight.flightAttendants.forEach { crewDetails.append("Comissário: \($0.name)") }
        return crewDetails
    }

    init(flight: Flight) {
        self.flight = flight
    }
}
