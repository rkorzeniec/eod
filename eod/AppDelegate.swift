//
//  AppDelegate.swift
//  eod
//
//  Created by Robert Korzeniec on 04.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import SwiftUI
import CoreData

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let userDefaults = UserDefaults.standard

    private var popover = NSPopover()
    private var userSettings = Settings()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        importData()
        loadUserSettings()
        
        guard let context = Optional(persistentContainer.viewContext) else {
            fatalError("Unable to read managed object context.")
        }

        let expectancy = calculateLifeExpectancyDays()
        let configureView = ContentView()
            .environment(\.managedObjectContext, context)
            .environmentObject(userSettings)
        
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
    
    private func importData() {
        let isDataImported = userDefaults.bool(forKey: "isDataImported")
        if !isDataImported {
            DataImporter(store: self.persistentContainer).importData()
            userDefaults.set(true, forKey: "isDataImported")
        }
    }
    
    private func loadUserSettings() {
        if let birthDate = userDefaults.object(forKey: "birthDate") as? Date {
            userSettings.birthDate = birthDate
        }
        
        if let birthPlace = userDefaults.object(forKey: "birthPlace") as? String {
            userSettings.birthPlace = birthPlace
        }
        
        if let gender = userDefaults.object(forKey: "gender") as? Int {
            userSettings.gender = gender
        }
    }
    
    private func calculateLifeExpectancyDays() -> Int {
        let birthYear = userSettings.birthYear()
        let gender = userSettings.genderName()
        let birthPlace = userSettings.birthPlace ?? "EUU"
        
        let recordRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        let predicateIso = NSPredicate(format: "countryIso == %@", birthPlace)
        let predicateYear = NSPredicate(format: "year == %d", birthYear)
        let predicateGender = NSPredicate(format: "gender == %@", gender)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateIso, predicateYear, predicateGender])
        recordRequest.predicate = compound
        recordRequest.fetchLimit = 1

        var expectancy: Double?
        do {
            let result = try persistentContainer.viewContext.fetch(recordRequest).first as! NSManagedObject
            expectancy = result.value(forKey: "value") as? Double
        } catch { print(error) }
  
        return LifeExpectancyCalculator(expectancy: expectancy ?? 67.7, birthDate: userSettings.birthDate).days()
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
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "eod")
        container.loadPersistentStores { description, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do { try context.save() } catch { NSApplication.shared.presentError(error) }
        }
    }

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }
}
