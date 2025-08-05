//
//  LanguangeRows.swift
//  WaterBoost
//
//  Created by Banu on 4.08.2025.
//

import SwiftUI

struct LanguangeRows: View {
   
    var country: Country
    
    var body: some View {
        HStack {
            country.countryImage
                .resizable()
                .frame(width: 45, height: 45)
            VStack(alignment: .leading) {
                Text(country.languangeName)
                    .foregroundStyle(.blue)
                Text(country.languangeAbbreviation)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
    
         Spacer()
            
        }
    }
}

struct Country {
    var countryImage: Image
    var languangeName: String
    var languangeAbbreviation: String
}

#Preview {
    LanguangeRows(country: Country(countryImage: Image(systemName: "target"), languangeName: "Türkçe", languangeAbbreviation: "TR"))
}
