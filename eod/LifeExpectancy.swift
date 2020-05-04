//
//  LifeExpectancy.swift
//  eod
//
//  Created by Robert Korzeniec on 04.05.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import Foundation
import CoreData

class LifeExpectancy {
    private let countryIso: String
    private let gender: String
    private let year: Int
    private let context: NSManagedObjectContext

    init(countryIso: String?, year: Int?, gender: String?, managedObjectContext: NSManagedObjectContext) {
        self.countryIso = countryIso ?? "EUU"
        self.year = year ?? 2000
        self.gender = gender ?? "male"
        self.context = managedObjectContext
    }
    
    func expectancy() -> Double {
        let record = fetchRecord()
        
        if let expectancy = record?.value(forKey: "value") as? Double { return expectancy }
        
        return 72.79 // average for World for 2018
    }
    
    private func fetchRecord() -> NSManagedObject? {
        // 72.29
        if let record = fetchUserRecord() { return record }
        if let record = fetchWorldRecord() { return record }
        
        return nil
    }
    
    private func fetchUserRecord() -> NSManagedObject? {
        let recordRequest = recordEntity()
        let compoundPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                predicateCountry(iso: countryIso),
                predicateYear(),
                predicateGender()
            ]
        )
        
        recordRequest.predicate = compoundPredicate
        recordRequest.fetchLimit = 1
        
        if let data = try? context.fetch(recordRequest).first as? NSManagedObject { return data }
        
        return nil
    }

    
    private func fetchWorldRecord() -> NSManagedObject? {
        let recordRequest = recordEntity()
        let compoundPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                predicateCountry(iso: "WLD"),
                predicateYear(),
                predicateGender()
            ]
        )
        
        recordRequest.predicate = compoundPredicate
        recordRequest.fetchLimit = 1
        
        if let data = try? context.fetch(recordRequest).first as? NSManagedObject { return data }
        
        return nil
    }
    
    private func recordEntity() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
    }
    
    private func predicateCountry(iso: String) -> NSPredicate {
        return NSPredicate(format: "countryIso == %@", iso)
    }
    
    private func predicateYear() -> NSPredicate {
        return NSPredicate(format: "year == %d", year)
    }

    private func predicateGender() -> NSPredicate {
        return NSPredicate(format: "gender == %@", gender)
    }
}
