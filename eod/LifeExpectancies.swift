//
//  LifeExpectancies.swift
//  eod
//
//  Created by Robert Korzeniec on 13.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import Foundation
import SwiftCSV

    var countries: [String : String] = [:]
class LifeExpectancies: ObservableObject {
    
    private var csv: CSV?
    
    init() {
        csv = try! CSV(name: "life_expectancy_at_birth.csv")
        retrieveCountries()
    }
    
    func expectancy(country iso: String, year: String, gender: String = "male") -> Double {
        var value = 0.0
        do {
            try csv?.enumerateAsDict { dict in
                guard dict["iso"] == iso, dict["gender"] == gender, !(dict[year]?.isEmpty ?? true) else { return }
                value = Double(dict[year]!)!
            }
        } catch { print("Something went wrong!") }
        
        return value
    }
    
    private func retrieveCountries() {
        do {
            try csv?.enumerateAsDict { dict in self.countries[dict["iso"]!] = dict["country"]! }
        } catch { print("Something went wrong!") }
    }
}
