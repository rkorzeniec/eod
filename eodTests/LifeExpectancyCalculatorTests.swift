//
//  LifeExpectancyCalculatorTests.swift
//  eodTests
//
//  Created by Robert Korzeniec on 04.05.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import XCTest
@testable import eod

class LifeExpectancyCalculatorTests: XCTestCase {
    var testCalculator: LifeExpectancyCalculator!

    override func setUpWithError() throws {
        testCalculator = LifeExpectancyCalculator(expectancy: 100, birthDate: Date())
    }

    override func tearDownWithError() throws {}

    func testDaysCalculation() throws {
        XCTAssertEqual(testCalculator.days(), 36525)
    }

    func testPerformanceExample() throws {
        self.measure {
            XCTAssertEqual(testCalculator.days(), 36525)
        }
    }

}
