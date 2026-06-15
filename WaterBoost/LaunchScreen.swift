//
//  LaunchScreen.swift
//  WaterBoost
//
//  Created by Banu on 18.07.2025.
//

import SwiftUI

struct LaunchScreen: View {
    let customDarkBlue = Color(red: 0x04/255, green: 0x2D/255, blue: 0x47/255)
    let mediumBlue = Color(red: 0x3B/255, green: 0x70/255, blue: 0x96/255)
    let deepBlue = Color(red: 0xB7/255, green: 0xDE/255, blue: 0xF6/255)
    var body: some View {
        VStack(spacing: 10) {
            Image("water-splash")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .shadow(radius: 8)
            Text("WaterBoost")
                .font(.title)
                .foregroundStyle(customDarkBlue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(  LinearGradient(gradient: Gradient(colors: [customDarkBlue, mediumBlue]), startPoint: .top, endPoint: .bottom).ignoresSafeArea())
    }
}
