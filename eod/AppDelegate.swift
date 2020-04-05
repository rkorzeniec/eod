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


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let expectancy = calculateLifeExpectancyDays()
        let configureView = ContentView()
        
        let menu = NSMenu()
        menu.addItem(withTitle: "Configure", action: #selector(togglePopover), keyEquivalent: "C")
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
    
    @objc func terminate() { NSApp.terminate(self) }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    func calculateLifeExpectancyDays() -> Int {
    //        let date = Date()
    //        let cal = Calendar.current
    //        let record = lifeExpectancyParser.records[32] // 1992
    //        let expectancy_record_days = Int(record.value * 365)
    //        let current_days = ((cal.component(.year, from: date) - record.year) * 365) + cal.ordinality(of: .day, in: .year, for: date)!
    //
    //        return expectancy_record_days - current_days
            return 1599
        }
}
