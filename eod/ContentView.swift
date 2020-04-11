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
            DatePicker(selection: $settings.birthDate, in: ...Date(), displayedComponents: .date, label: { Text("Birth date") }).padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static let settings = Settings()
    
    static var previews: some View {
        ContentView().environmentObject(settings)
    }
}
