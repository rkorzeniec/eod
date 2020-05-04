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
        let expectancyDate = Date(timeInterval: TimeInterval(expectancyInSeconds()), since: birthDate)
        let days = calculateDiffBetweenDates(date1: Date(), date2: expectancyDate)
        
        return days
    }
    
    private func expectancyInSeconds() -> Double {
        return expectancy * 365.25 * 24 * 3600
    }
    
    private func calculateDiffBetweenDates(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        let calendarDate1 = calendar.startOfDay(for: date1)
        let calendarDate2 = calendar.startOfDay(for: date2)
        let dateDiff = calendar.dateComponents([.day], from: calendarDate1, to: calendarDate2)
        
        return dateDiff.day!
    }
}
