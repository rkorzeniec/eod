//
//  LifeExpectancyCalculator.swift
//  eod
//
//  Created by Robert Korzeniec on 13.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import Foundation

class LifeExpectancyCalculator {
    private let expectancy: Double
    private let birthDate: Date
    
    init(expectancy: Double, birthDate: Date) {
        self.expectancy = expectancy
        self.birthDate = birthDate
    }
    
    func days() -> Int {
        let expectancyInSeconds = expectancy * 365.25 * 24 * 3600
        let expectancyDate = Date(timeInterval: TimeInterval(expectancyInSeconds), since: birthDate)
        
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: expectancyDate)
        
        return calendar.dateComponents([.day], from: date1, to: date2).day!
    }
}
