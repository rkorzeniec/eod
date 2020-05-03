//
//  DataImporter.swift
//  eod
//
//  Created by Robert Korzeniec on 19.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//  Data for males: https://data.worldbank.org/indicator/SP.DYN.LE00.MA.IN
//  Data for females: https://data.worldbank.org/indicator/SP.DYN.LE00.FE.IN
//

import Foundation
import SwiftCSV
import CoreData

class DataImporter {
    private var csv: CSV?
    private var exludedStates: [String] = [
        "CEB", "EAP", "EAR", "EAS", "ECA", "ECS", "EMU", "FCS", "HPC", "IBD", "IBT", "IDA",
        "IDB", "IDX", "INX", "LAC", "LDC", "LIC", "LMC", "LMY", "LTE", "MEA", "MIC", "MNA",
        "OED", "OSS", "PRE", "PST", "SSA", "SSF", "SST", "TEA", "TEC", "TLA", "TMN", "TSA",
        "TSS", "UMC"
    ]
    
    var store: NSPersistentContainer
    
    init(store: NSPersistentContainer) {
        self.store = store
        self.csv = try! CSV(name: "life_expectancy_at_birth.csv")
    }
    
    func importData() {
        guard !store.name.isEmpty else { return }
        
        let context = store.viewContext
        let countryEntity = NSEntityDescription.entity(forEntityName: "Country", in: context)!
        let recordEntity = NSEntityDescription.entity(forEntityName: "Record", in: context)!
        let expectancyEntity = NSEntityDescription.entity(forEntityName: "Expectancy", in: context)!
        
        do {
            try csv?.enumerateAsDict { dict in
            
                guard !self.exludedStates.contains(dict["iso"]!) else { return }
                
                var country = self.fetchCountry(context: context, entity: countryEntity, query: dict["iso"]!)
                if country == nil {
                    country = self.createCountry(context: context, entity: countryEntity, iso: dict["iso"]!, name: dict["country"]!)
                }
                
                let expectancy = NSManagedObject(entity: expectancyEntity, insertInto: context)
                
                expectancy.setValue(dict["gender"]!, forKey: "gender")
                expectancy.setValue(country, forKey: "country")
                
                for year in 1960...2018 {
                    guard let yearExpectancy = dict[String(year)] else { continue }
                    guard !yearExpectancy.isEmpty else { continue }
                    
                    let record = self.createRecord(context: context, entity: recordEntity, year: year, expectancy: Double(yearExpectancy)!)

                    expectancy.setValue(NSSet(object: record), forKey: "records")
                }
                    
                do { try expectancy.managedObjectContext?.save() } catch { print(error) }
            }
        } catch { print("Something went wrong!") }
    }
    
    private func fetchCountry(context: NSManagedObjectContext, entity: NSEntityDescription, query: String) -> NSManagedObject? {
        let countryRequest = NSFetchRequest<NSFetchRequestResult>()
        var country: NSManagedObject?
        
        countryRequest.entity = entity
        countryRequest.predicate = NSPredicate(format: "iso == %@", query)
        
        do { country = try context.fetch(countryRequest).first as? NSManagedObject } catch { print(error) }
                
        return country
    }
    
    private func createCountry(context: NSManagedObjectContext, entity: NSEntityDescription, iso: String, name: String) -> NSManagedObject {
        let country = NSManagedObject(entity: entity, insertInto: context)
        country.setValue(name, forKey: "name")
        country.setValue(iso, forKey: "iso")
        
        do { try country.managedObjectContext?.save()} catch { print(error) }
        
        return country
    }
    
    private func createRecord(context: NSManagedObjectContext, entity: NSEntityDescription, year: Int, expectancy: Double) -> NSManagedObject {
        let record = NSManagedObject(entity: entity, insertInto: context)
        record.setValue(expectancy, forKey: "value")
        record.setValue(year, forKey: "year")
        
        do { try record.managedObjectContext?.save()} catch { print(error) }
        
        return record
    }
}
