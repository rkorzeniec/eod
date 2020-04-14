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

    var body: some View {
        VStack {
            Picker(selection: $settings.gender, label: Text("Gender:")) {
                Text("Male").tag(0)
                Text("Female").fixedSize().tag(1)
            }.pickerStyle(RadioGroupPickerStyle())

            DatePicker(selection: $settings.birthDate, in: ...toDate, displayedComponents: .date) {
                Text("Birth date")
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
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static let settings = Settings()
    
    static var previews: some View {
        ContentView().environmentObject(settings)
    }
}
