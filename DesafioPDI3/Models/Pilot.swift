//
//  Pilot.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 22/07/24.
//

import Foundation

struct Pilot {
    let name: String
    let experience: Int
    
    
    init(name: String, experience: Int) {
        self.name = name
        self.experience = experience
    }
    
    func isPilot() -> Bool {
        return experience > 5
    }
    
}

struct CoPilot {
    let name: String
    let experience: Int
    
    
    init(name: String, experience: Int) {
        self.name = name
        self.experience = experience
    }
}
    
