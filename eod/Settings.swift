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
    @Published var gender: Int
    
    init() {
        birthDate = Date()
        birthPlace = "EUU"
        gender = 0
    }
    
    func birthYear() -> Int {
        return Calendar(identifier: .iso8601).component(.year, from: birthDate)
    }
    
    func genderName() -> String {
        return gender == 0 ? "male" : "female"
    }
}
