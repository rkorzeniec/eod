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

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let lifeExpectancies = LifeExpectancies()
    private let userDefaults = UserDefaults.standard

    private var popover = NSPopover()
    private var userSettings = Settings()
    private var timer: Timer?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        updateUserSettings()
        
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
        
        setTimer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        timer?.invalidate()
    }
    
    @objc func updateLifeExpectancy() {
        let expectancy = calculateLifeExpectancyDays()
        statusItem.button?.title = "\(expectancy)"
        userDefaults.set(userSettings.birthDate, forKey: "birthDate")
        userDefaults.set(userSettings.gender, forKey: "gender")
    }
    
    @objc private func terminate() { NSApp.terminate(self) }

    @objc private func togglePopover(_ sender: AnyObject?) {
        popover.isShown == true ? closePopover(sender) : showPopover(sender)
    }
    
    private func updateUserSettings() {
        if let birthDate = userDefaults.object(forKey: "birthDate") as? Date {
            userSettings.birthDate = birthDate
        }
        
        if let gender = userDefaults.object(forKey: "gender") as? Int {
            userSettings.gender = gender
        }
    }
    
    private func calculateLifeExpectancyDays() -> Int {
        let birthPlace = userSettings.birthPlace
        let birthYear = String(userSettings.birthYear())
        let gender = userSettings.genderName()
        let expectancy = lifeExpectancies.expectancy(country: birthPlace, year: birthYear, gender: gender)
        
        return LifeExpectancyCalculator(expectancy: expectancy, birthDate: userSettings.birthDate).days()
    }
    
    private func setTimer() {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let dayInSeconds = TimeInterval(24 * 3600)
        
        timer?.invalidate()
        
        timer = Timer(
            fireAt: Calendar.current.startOfDay(for: tomorrow),
            interval: dayInSeconds,
            target: self,
            selector: #selector(updateLifeExpectancy),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(timer!, forMode: .common)
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
