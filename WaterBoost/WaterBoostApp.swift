//
//  WaterBoostApp.swift
//  WaterBoost
//
//  Created by Banu on 29.03.2025.
//

import SwiftUI

@main
struct WaterBoostApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
               OnboardingView()
            } else {
               MainTabbedView()
            }
        }
    }
}
