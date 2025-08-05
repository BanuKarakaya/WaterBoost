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
    @State private var showListView = false
    let lastAlertDateKey = "lastAlertDate"
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
            } else {
                if isActive {
                    if showListView {
                        DailyGoalScreen()
                    } else {
                        MainTabbedView()
                    }
                } else {
                   LaunchScreen()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                withAnimation {
                                    self.isActive = true
                            }
                        }
                            checkIfAlertShownToday()
                    }
                }
            }
        }
    }

    func checkIfAlertShownToday() {
        if let lastAlertDate = UserDefaults.standard.object(forKey: lastAlertDateKey) as? Date {
            if Calendar.current.isDateInToday(lastAlertDate) {
                print("Alert was shown today!")
            } else {
                showAlert()
            }
        } else {
            showAlert()
        }
    }

    func showAlert() {
        print("Need to show an alert today!")
        UserDefaults.standard.set(Date(), forKey: lastAlertDateKey)
        showListView = true
    }
}
