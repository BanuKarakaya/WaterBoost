//
//  WaterBoostApp.swift
//  WaterBoost
//
//  Created by Banu on 29.03.2025.
//

import SwiftUI
import UserNotifications

@main
struct WaterBoostApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @State private var isActive = false
    @State private var showListView = false
    let lastAlertDateKey = "lastAlertDate"
    @StateObject private var model = MyModel()
    
    init() {
        setupNotificationDelegate()
    }
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
                    .environmentObject(model)
                    .preferredColorScheme(.dark)
            } else {
                if isActive {
                    if showListView {
                        DailyGoalScreen()
                            .environmentObject(model)
                            .preferredColorScheme(.dark)
                    } else {
                        MainTabbedView()
                            .environmentObject(model)
                            .preferredColorScheme(.dark)
                    }
                } else {
                   LaunchScreen()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    self.isActive = true
                            }
                        }
                            checkIfAlertShownToday()
                    }
                    .environmentObject(model)
                    .preferredColorScheme(.dark)
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
    
    func setupNotificationDelegate() {
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        model.setupNotifications()
        print("🔔 Notification delegate setup completed")
    }
}

// Notification Delegate Class
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("🔔 Notification shown: \(notification.request.identifier)")
        
        // Check if it's the goal incomplete notification (saat 23:00)
        if notification.request.identifier == "goalIncomplete" {
            // Check if goal is still not reached
            let waterConsumed = Int(UserDefaults.standard.string(forKey: "waterConsumed") ?? "0") ?? 0
            let dailyGoal = Int(UserDefaults.standard.string(forKey: "dailyGoal") ?? "2000") ?? 2000
            let hasReachedGoal = UserDefaults.standard.bool(forKey: HomeView.todayKey())
            
            if !hasReachedGoal && waterConsumed < dailyGoal {
                print("⏰ 23:00 - Goal not reached, unlocking apps until tomorrow")
                MyModel.shared.unlockApps()
            }
        }
        
        completionHandler([.alert, .sound])
    }
    
    // Handle notification when user taps it
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("🔔 User tapped notification: \(response.notification.request.identifier)")
        
        // Check if it's the goal incomplete notification
        if response.notification.request.identifier == "goalIncomplete" {
            // Check if goal is still not reached
            let waterConsumed = Int(UserDefaults.standard.string(forKey: "waterConsumed") ?? "0") ?? 0
            let dailyGoal = Int(UserDefaults.standard.string(forKey: "dailyGoal") ?? "2000") ?? 2000
            let hasReachedGoal = UserDefaults.standard.bool(forKey: HomeView.todayKey())
            
            if !hasReachedGoal && waterConsumed < dailyGoal {
                print("⏰ 23:00 - Goal not reached, unlocking apps until tomorrow")
                MyModel.shared.unlockApps()
            }
        }
        
        completionHandler()
    }
}
