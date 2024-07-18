//
//  Passenger.swift
//  DesafioPDI3
//
//  Created by Vitoria Ortega on 18/07/24.
//

import Foundation

struct Passenger {
    let name: String
    let age: Int
    
    var isMinor: Bool {
        return age < 18
    }
}
