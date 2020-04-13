//
//  LifeExpectancyAtBirthParser.swift
//  end_of_days
//
//  Created by Robert on 25.08.18.
//  Copyright © 2018 rkorzeniec. All rights reserved.
//

import Foundation

class LifeExpectancyAtBirthParser: NSObject, XMLParserDelegate {
    var records: [Int: Double] = [:]
    
    func parseXml() {
        if let path = Bundle.main.url(forResource: "life_expectancy_at_birth_eu_total", withExtension: "xml") {
            if let parser = XMLParser.init(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "record" {
            records[Int(attributeDict["year"]!)!] = Double(attributeDict["value"]!)!
        }
    }
}
