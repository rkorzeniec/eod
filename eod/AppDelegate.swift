//
//  AppDelegate.swift
//  eod
//
//  Created by Robert Korzeniec on 04.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var popover = NSPopover()
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let lifeExpectancyParser = LifeExpectancyAtBirthParser()

    private let userDefaults = UserDefaults.standard
    private var userSettings = Settings()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        lifeExpectancyParser.parseXml()
        if let birthDate = userDefaults.object(forKey: "birthDate") as? Date {
            userSettings.birthDate = birthDate
        }
        
        let expectancy = calculateLifeExpectancyDays()
        let configureView = ContentView().environmentObject(userSettings)
        let menu = NSMenu()
        
        menu.addItem(withTitle: "Configure", action: #selector(togglePopover), keyEquivalent: "c")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit", action: #selector(terminate), keyEquivalent: "q")
        
        statusItem.menu = menu
        statusItem.button?.title = "\(expectancy)"
        statusItem.button?.action = #selector(togglePopover)
        
        popover.contentSize = NSSize(width: 200, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: configureView)
    }

    func applicationWillTerminate(_ aNotification: Notification) { }
    
    func updateLifeExpectancy() {
        let expectancy = calculateLifeExpectancyDays()
        statusItem.button?.title = "\(expectancy)"
        userDefaults.set(userSettings.birthDate, forKey: "birthDate")
    }
    
    @objc private func terminate() { NSApp.terminate(self) }

    @objc private func togglePopover(_ sender: AnyObject?) {
        popover.isShown == true ? closePopover(sender) : showPopover(sender)
    }
    
    private func calculateLifeExpectancyDays() -> Int {
        let date = Date()
        let cal = Calendar.current
        
        let year = Calendar(identifier: .iso8601).component(.year, from: userSettings.birthDate)
        let value = lifeExpectancyParser.records[year]!
        let expectancy_record_days = Int(value * 365)
        
        let current_days = ((cal.component(.year, from: date) - year) * 365) + cal.ordinality(of: .day, in: .year, for: date)!
        
        return expectancy_record_days - current_days
    }
    
    private func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    private func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }
}
