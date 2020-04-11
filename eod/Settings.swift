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
    
    init() {
        birthDate = Date()
    }
    
    func birthYear() -> Int {
        return Calendar(identifier: .iso8601).component(.year, from: birthDate)
    }
}
