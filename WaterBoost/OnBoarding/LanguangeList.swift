//
//  LanguangeList.swift
//  WaterBoost
//
//  Created by Banu on 5.08.2025.
//

import SwiftUI

struct LanguangeList: View {
    
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    let darkChartBlue = Color(red: 4/255, green: 43/255, blue: 66/255)
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: ListView()) {
                    LanguangeRows(country: Country(
                        countryImage: Image(systemName: "target"),
                        languangeName: "Türkçe",
                        languangeAbbreviation: "TR"))
                }
                .listRowBackground(darkChartBlue)
            }
            .scrollContentBackground(.hidden)
            .background(LinearGradient(gradient: Gradient(colors: [darkBlue, Color.blue]), startPoint: .top, endPoint: .bottom))
            .navigationTitle("Choose Language")
        } detail: {
            Text("Select a Language")
                .foregroundColor(.white)
                .background(darkBlue)
        }
    }
}

#Preview {
    LanguangeList()
}

