//
//  LifeExpectancies.swift
//  eod
//
//  Created by Robert Korzeniec on 13.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import Foundation
import SwiftCSV

class LifeExpectancies: ObservableObject {
    @Published var countries: [String] = []
    
    private var csv: CSV?
    
    init() {
        csv = try! CSV(name: "life_expectancy_at_birth.csv")
        retrieveCountries()
    }
    
    func expectancy(country iso: String, year: String, gender: String = "male") -> Double {
        var value = 0.0
        do {
            try csv?.enumerateAsDict { dict in
                guard dict["country"] == iso, dict["gender"] == gender, !(dict[year]?.isEmpty ?? true) else { return }
                value = Double(dict[year]!)!
            }
        } catch { print("Something went wrong!") }
        
        return value
    }
    
    func country(index: Int) -> String {
        return countries[index]
    }
    
    private func retrieveCountries() {
        do {
            try csv?.enumerateAsDict { dict in
                if !self.countries.contains(dict["country"]!) {
                    self.countries.append(dict["country"]!)
                }
            }
        } catch { print("Something went wrong!") }
        countries = self.countries.sorted()
    }
}
