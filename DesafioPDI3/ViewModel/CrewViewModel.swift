//
//  CrewViewModel.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 15/10/24.
//

import Foundation

class CrewViewModel {

    var pilots: [Pilot] = []
    var coPilots: [CoPilot] = []
    var flightAttendants: [FlightAttendant] = []

    var onExperienceLabelUpdate: ((String) -> Void)?
    var onCrewUpdated: (() -> Void)?

    func updateUI(for selectedIndex: Int) {
        if selectedIndex == 0 {
            onExperienceLabelUpdate?("Experiência: 1 ano(s)")
        } else {
            onExperienceLabelUpdate?("Experiência mínima não requerida")
        }
    }

    func updateExperienceLabel(value: Double) {
        onExperienceLabelUpdate?("Experiência: \(Int(value)) ano(s)")
    }

    func addCrewMember(name: String, experience: Int, role: Int) {
        if role == 0 {
            if experience >= 5 {
                let newPilot = Pilot(name: name, experience: experience)
                pilots.append(newPilot)
            } else {
                let newCoPilot = CoPilot(name: name, experience: experience)
                coPilots.append(newCoPilot)
            }
        } else {
            let newFlightAttendant = FlightAttendant(name: name)
            flightAttendants.append(newFlightAttendant)
        }
        onCrewUpdated?()
    }

    func crewMember(at index: Int) -> String {
        if index < pilots.count {
            let pilot = pilots[index]
            return "Piloto: \(pilot.name), Experiência: \(pilot.experience) ano(s)"
        } else if index < pilots.count + coPilots.count {
            let coPilot = coPilots[index - pilots.count]
            return "Co-Piloto: \(coPilot.name), Experiência: \(coPilot.experience) ano(s)"
        } else {
            let flightAttendant = flightAttendants[index - pilots.count - coPilots.count]
            return "Comissário: \(flightAttendant.name)"
        }
    }

    func deleteCrewMember(at index: Int) {
        if index < pilots.count {
            pilots.remove(at: index)
        } else if index < pilots.count + coPilots.count {
            coPilots.remove(at: index - pilots.count)
        } else {
            flightAttendants.remove(at: index - pilots.count - coPilots.count)
        }
        onCrewUpdated?()
    }

    func crewCount() -> Int {
        return pilots.count + coPilots.count + flightAttendants.count
    }

    func hasCrew() -> Bool {
        return !pilots.isEmpty || !coPilots.isEmpty || !flightAttendants.isEmpty
    }
}
