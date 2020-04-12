//
//  LifeExpectancyAtBirthParserTests.swift
//  eodTests
//
//  Created by Robert Korzeniec on 12.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import XCTest
@testable import eod

class LifeExpectancyAtBirthParserTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    func testParsingXml() throws {
        let parser = LifeExpectancyAtBirthParser()
        
        XCTAssertNoThrow(parser.parseXml())
    }
    
    func testRecordsExist() throws {
        let parser = LifeExpectancyAtBirthParser()
        parser.parseXml()
        
        XCTAssertNotNil(parser.records)
    }
    
    func testRecordsStartAt1960() throws {
        let parser = LifeExpectancyAtBirthParser()
        parser.parseXml()
        
        XCTAssertEqual(parser.records.keys.sorted().first, 1960)
        XCTAssertEqual(parser.records.values.sorted().first, 65.4110454019315)
    }
    
    func testRecordsEndsAt2017() throws {
        let parser = LifeExpectancyAtBirthParser()
        parser.parseXml()
        
        XCTAssertEqual(parser.records.keys.sorted().last, 2017)
        XCTAssertEqual(parser.records.values.sorted().last, 73.3777083800028)
    }

    func testPerformanceExample() throws {
        self.measure {
            LifeExpectancyAtBirthParser().parseXml()
        }
    }

}
