//
//  ContentView.swift
//  eod
//
//  Created by Robert Korzeniec on 04.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var lifeExpectancies: LifeExpectancies
    
    var genders = ["Male", "Female"]

    var body: some View {
        VStack {
            Picker(selection: $settings.gender, label: Text("Gender:")) {
                ForEach(0 ..< genders.count) {
                    Text(self.genders[$0]).fixedSize()
                }
            }.pickerStyle(RadioGroupPickerStyle())

            DatePicker(selection: $settings.birthDate, in: ...toDate, displayedComponents: .date) {
                Text("Birth date:")
            }
            
            Picker(selection: $settings.birthPlace, label: Text("Birth place:")) {
                ForEach(0 ..< lifeExpectancies.countries.count) {
                    Text(self.lifeExpectancies.countries[$0])
                }
            }
            
            Button(action: updateExpectancy) { Text("Save") }
        }.padding()
    }
    
    var toDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        return formatter.date(from: "31/12/2017")!
    }
    
    
    func updateExpectancy() {
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.updateLifeExpectancy()
            appDelegate.updateSettings()
            appDelegate.togglePopover()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static let settings = Settings()
    
    static var previews: some View {
        ContentView().environmentObject(settings)
    }
}
