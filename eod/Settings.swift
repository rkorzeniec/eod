//
//  Settings.swift
//  eod
//
//  Created by Robert Korzeniec on 05.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import Foundation

class Settings: ObservableObject {
    @Published var birthDate: Date
    @Published var birthPlace: String
    @Published var gender: String
    
    init() {
        birthDate = Date()
        birthPlace = "EUU"
        gender = "male"
    }
    
    func birthYear() -> Int {
        return Calendar(identifier: .iso8601).component(.year, from: birthDate)
    }
}
