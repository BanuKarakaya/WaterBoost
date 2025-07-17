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
    @State private var isActive = false
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
               OnboardingView()
            } else {
                if isActive {
                   MainTabbedView()
                } else {
                   LaunchScreen()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                withAnimation {
                                    self.isActive = true
                            }
                        }
                    }
                }
            }
        }
    }
}
