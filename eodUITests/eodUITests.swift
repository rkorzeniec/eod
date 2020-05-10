//
//  eodUITests.swift
//  eodUITests
//
//  Created by Robert Korzeniec on 04.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import XCTest

class eodUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(contentsOf: ["-settings.birthDate", "\(Date())"])
        app.launchArguments.append(contentsOf: ["-settings.birthPlace", "WLD"])
        app.launchArguments.append(contentsOf: ["-settings.gender", "female"])
        app.launch()
    }

    override func tearDownWithError() throws {}

    func testConfigurePopoverShow() throws {
        app.menuBars.statusItems["27389"].click()
        app.typeKey("c", modifierFlags:.command)
    }
    
    func testQuitAppViaShortcut() throws {
        app.menuBars.statusItems["27389"].click()
        app.typeKey("q", modifierFlags:.command)
    }
    
    func testPopoverHideAfterSave() throws {
        
                
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
