//
//  SettingsTests.swift
//  eodTests
//
//  Created by Robert Korzeniec on 12.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import XCTest
@testable import eod


class SettingsTests: XCTestCase {
    var testSettings: Settings!
    
    override func setUpWithError() throws {
        testSettings = Settings()
    }
    
    override func tearDownWithError() throws {}
    
    func testInitBirthDate() {
        XCTAssertNotNil(testSettings.birthDate)
        XCTAssertTrue(testSettings.birthDate.timeIntervalSinceNow <= 100)
        XCTAssertLessThanOrEqual(
            testSettings.birthDate.timeIntervalSince1970,
            Date().timeIntervalSince1970
        )
    }
    
    func testInitBirthPlace() {
        XCTAssertNil(testSettings.birthPlace)
    }
    
    func testCustomBirthPlace() {
        testSettings.birthPlace = "GBR"
        XCTAssertEqual(testSettings.birthPlace, "GBR")
    }
    
    func testInitGender() {
        XCTAssertEqual(testSettings.gender, 0)
    }

    func testDefaultBirthYear() {
        XCTAssertEqual(
            testSettings.birthYear(),
            Calendar(identifier: .iso8601).component(.year, from: Date())
        )
    }
    
    func testCustomBirthYear() {
        testSettings.birthDate = Date(timeIntervalSinceReferenceDate: 0)
        XCTAssertEqual(testSettings.birthYear(), 2001)
    }
    
    func testDefaultGenderName() {
        XCTAssertEqual(testSettings.genderName(), "male")
    }
    
    func testCustomGenderName() {
        testSettings.gender = 1
        XCTAssertEqual(testSettings.genderName(), "female")
    }

    func testPerformanceExample() throws {
        self.measure {
            XCTAssertEqual(testSettings.birthYear(), Calendar(identifier: .iso8601).component(.year, from: Date()))
        }
    }

}
