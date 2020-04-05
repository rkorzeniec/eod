//
//  ContentView.swift
//  eod
//
//  Created by Robert Korzeniec on 04.04.20.
//  Copyright © 2020 Robert Korzeniec. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var birthDate = Date()

    var body: some View {
        VStack {
            VStack {
                DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date, label: { Text("Date of birth") })
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) { Text("Save") }
            }.padding([.leading, .top, .trailing], 10)
            
            Divider()
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
