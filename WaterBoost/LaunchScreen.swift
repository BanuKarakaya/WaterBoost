//
//  LaunchScreen.swift
//  WaterBoost
//
//  Created by Banu on 18.07.2025.
//

import SwiftUI

struct LaunchScreen: View {
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    let lightBlue = Color(red: 183 / 255, green: 222 / 255, blue: 250 / 255)
    var body: some View {
        VStack(spacing: 10) {
            Image("water-splash")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .shadow(radius: 8)
            Text("WaterBoost")
                .font(.title)
                .foregroundStyle(lightBlue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(darkBlue)
    }
}
