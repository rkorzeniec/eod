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
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    func testInitSettings() {
        let testSettings = Settings()
        
        XCTAssertNotNil(testSettings.birthDate)
        XCTAssertTrue(testSettings.birthDate.timeIntervalSinceNow <= 100)
        XCTAssertLessThanOrEqual(testSettings.birthDate.timeIntervalSince1970, Date().timeIntervalSince1970)
    }

    func testBirthYear() {
        let testSettings = Settings()
        
        XCTAssertEqual(testSettings.birthYear(), Calendar(identifier: .iso8601).component(.year, from: Date()))
    }

    func testPerformanceExample() throws {
        self.measure {
            let testSettings = Settings()
            XCTAssertEqual(testSettings.birthYear(), Calendar(identifier: .iso8601).component(.year, from: Date()))
        }
    }

}
