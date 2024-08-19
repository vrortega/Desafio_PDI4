//
//  PassengersViewModel.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 14/10/24.
//

import Foundation

class PassengersViewModel {
    var passengersDidUpdate: (() -> Void)?
    var showError: ((String) -> Void)?
    
    var passengers: [Passenger] = [] {
        didSet {
            passengersDidUpdate?()
        }
    }
    
    func addPassenger(name: String?, ageText: String?) {
        guard let name = name, !name.isEmpty,
              let ageText = ageText, !ageText.isEmpty,
              let age = Int(ageText) else {
            showError?("Por favor, insira um nome e uma idade válidos.")
            return
        }
        
        let newPassenger = Passenger(name: name, age: age)
        
        if newPassenger.isMinor {
            showError?("Passageiro menor de idade não pode embarcar.")
            return
        }
        
        passengers.append(newPassenger)
    }
    
    func removePassenger(at index: Int) {
        guard index >= 0 && index < passengers.count else { return }
        passengers.remove(at: index)
    }
    
    func numberOfPassengers() -> Int {
        return passengers.count
    }
    
    func passenger(at index: Int) -> Passenger? {
        guard index >= 0 && index < passengers.count else { return nil }
        return passengers[index]
    }
}
