//
//  NewFlightViewModel.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 16/10/24.
//

import Foundation

class NewFlightViewModel {
    
    var origin: String = ""
    var destination: String = ""
    var capacity: Int = 1 {
        didSet {
            updateCapacityLabel?("Capacidade de \(capacity) pessoa(s)")
        }
    }
    var departureDate: Date = Date()
    var returnDate: Date? = nil
    var isOneWay: Bool = false {
        didSet {
            updateOneWayState?(isOneWay)
        }
    }
    
    var passengers: [Passenger] = [] {
        didSet {
            updatePassengerLabel?(passengerLabelText)
        }
    }
    var pilots: [Pilot] = []
    var coPilots: [CoPilot] = []
    var flightAttendants: [FlightAttendant] = [] {
        didSet {
            updateCrewLabel?(crewLabelText)
        }
    }
    
    var onFlightAdded: ((Flight) -> Void)?
    
    var updateCapacityLabel: ((String) -> Void)?
    var updateOneWayState: ((Bool) -> Void)?
    var updatePassengerLabel: ((String) -> Void)?
    var updateCrewLabel: ((String) -> Void)?
    
    var passengerLabelText: String {
        return passengers.isEmpty ? "Nenhum passageiro adicionado" : "\(passengers.count) passageiro(s) adicionado(s)"
    }
    
    var crewLabelText: String {
        let totalCrew = pilots.count + coPilots.count + flightAttendants.count
        return totalCrew == 0 ? "Nenhum tripulante adicionado" : "\(totalCrew) tripulante(s) adicionado(s)"
    }
    
    func validateCities() -> Bool {
        return origin.count == 3 && destination.count == 3
    }
    
    func validateCrew() -> Bool {
        print("número de pilotos: \(pilots.count)")
        print("número de copilotos: \(coPilots.count)")
        print("número de comissário: \(flightAttendants.count)")
        let isValidCrew = pilots.count == 1 && coPilots.count == 1 && (flightAttendants.count >= 1 && flightAttendants.count <= 3)
    
        print("a tripulacao é valida? \(isValidCrew)")
        return isValidCrew
    }
    
    func validateCapacity() -> Bool {
        let totalPeople = pilots.count + coPilots.count + flightAttendants.count + passengers.count
        return capacity >= totalPeople
    }
    
    func addFlight() {
        guard validateCities(), validateCrew(), validateCapacity() else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let departureDateStr = dateFormatter.string(from: departureDate)
        let returnDateStr = isOneWay ? nil : dateFormatter.string(from: returnDate ?? Date())
        
        let flight = Flight(
            origin: origin,
            destination: destination,
            capacity: capacity,
            departureDate: departureDateStr,
            returnDate: returnDateStr,
            pilots: pilots,
            coPilots: coPilots,
            flightAttendants: flightAttendants,
            passengers: passengers
        )
        
        onFlightAdded?(flight)
    }
}
