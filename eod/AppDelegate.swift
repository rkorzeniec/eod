//
//  AppDelegate.swift
//  eod
//
//  Created by Robert Korzeniec on 04.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let lifeExpectancies = LifeExpectancies()
    private let userDefaults = UserDefaults.standard

    private var popover = NSPopover()
    private var userSettings = Settings()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        loadUserSettings()
        
        let expectancy = calculateLifeExpectancyDays()
        let configureView = ContentView().environmentObject(userSettings).environmentObject(lifeExpectancies)
        let menu = NSMenu()
        
        menu.addItem(withTitle: "Configure", action: #selector(togglePopover), keyEquivalent: "c")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit", action: #selector(terminate), keyEquivalent: "q")
        
        statusItem.menu = menu
        statusItem.button?.title = "\(expectancy)"
        
        popover.contentSize = NSSize(width: 200, height: 400)
        popover.contentViewController = NSHostingController(rootView: configureView)
        
        subscribeToDayChange()
    }

    func applicationWillTerminate(_ aNotification: Notification) { }
    
    @objc func updateLifeExpectancy() {
        DispatchQueue.main.async {
            let expectancy = self.calculateLifeExpectancyDays()
            self.statusItem.button?.title = "\(expectancy)"
        }
    }
    
    func updateSettings() {
        DispatchQueue.main.async {
            self.userDefaults.set(self.userSettings.birthDate, forKey: "birthDate")
            self.userDefaults.set(self.userSettings.birthPlace, forKey: "birthPlace")
            self.userDefaults.set(self.userSettings.gender, forKey: "gender")
        }
    }
    
    @objc func togglePopover() {
        popover.isShown == true ? closePopover() : showPopover()
    }
    
    @objc private func terminate() { NSApp.terminate(self) }
    private func loadUserSettings() {
        if let birthDate = userDefaults.object(forKey: "birthDate") as? Date {
            userSettings.birthDate = birthDate
        }
        
        if let birthPlace = userDefaults.object(forKey: "birthPlace") as? Int {
            userSettings.birthPlace = birthPlace
        }
        
        if let gender = userDefaults.object(forKey: "gender") as? Int {
            userSettings.gender = gender
        }
    }
    
    private func calculateLifeExpectancyDays() -> Int {
        let birthPlace = lifeExpectancies.country(index: userSettings.birthPlace)
        let birthYear = String(userSettings.birthYear())
        let gender = userSettings.genderName()
        let expectancy = lifeExpectancies.expectancy(country: birthPlace, year: birthYear, gender: gender)
        
        return LifeExpectancyCalculator(expectancy: expectancy, birthDate: userSettings.birthDate).days()
    }
    
    private func subscribeToDayChange() {
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(updateLifeExpectancy),
            name:.NSCalendarDayChanged,
            object:nil
        )
    }
    
    private func showPopover() {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    private func closePopover() {
        popover.close()
    }
}
