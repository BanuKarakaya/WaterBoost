//
//  MyModel.swift
//  WaterBoost
//
//  Created by Banu on 7.08.2025.
//

import Foundation
import ManagedSettings
import DeviceActivity
import FamilyControls
import SwiftUI
import UserNotifications

private let _AppBlockerModel = MyModel()

class MyModel: ObservableObject {
    public let store = ManagedSettingsStore()
    private let center = DeviceActivityCenter()
    
    @Published var selectionToDiscourage: FamilyActivitySelection
    @AppStorage("categoryTokensData", store: UserDefaults(suiteName: "group.com.banu.waterboost")) private var categoryTokensData: Data?
    @AppStorage("applicationTokensData", store: UserDefaults(suiteName: "group.com.banu.waterboost")) private var applicationTokensData: Data?
    @AppStorage("webDomainTokensData", store: UserDefaults(suiteName: "group.com.banu.waterboost")) private var webDomainTokensData: Data?
    
    private let lockScheduleName = DeviceActivityName("lock")
    private let unlockScheduleName = DeviceActivityName("unlock")
    
    var categoryTokens: Set<ActivityCategoryToken>? {
        get {
            if let data = categoryTokensData {
                let decoder = JSONDecoder()
                if let decodedTokens = try? decoder.decode(Set<ActivityCategoryToken>.self, from: data) {
                    return decodedTokens
                }
            }
            return nil
        }
        set {
            if let newTokens = newValue {
                let encoder = JSONEncoder()
                if let encodedData = try? encoder.encode(newTokens) {
                    categoryTokensData = encodedData
                } else {
                    categoryTokensData = nil
                }
            } else {
                categoryTokensData = nil
            }
        }
    }
    
    var applicationTokens: Set<ApplicationToken>? {
        get {
            if let data = applicationTokensData {
                let decoder = JSONDecoder()
                if let decodedTokens = try? decoder.decode(Set<ApplicationToken>.self, from: data) {
                    return decodedTokens
                }
            }
            return nil
        }
        set {
            if let newTokens = newValue {
                let encoder = JSONEncoder()
                if let encodedData = try? encoder.encode(newTokens) {
                    applicationTokensData = encodedData
                } else {
                    applicationTokensData = nil
                }
            } else {
                applicationTokensData = nil
            }
        }
    }
    
    var webDomainTokens: Set<WebDomainToken>? {
        get {
            if let data = webDomainTokensData {
                let decoder = JSONDecoder()
                if let decodedTokens = try? decoder.decode(Set<WebDomainToken>.self, from: data) {
                    return decodedTokens
                }
            }
            return nil
        }
        set {
            if let newTokens = newValue {
                let encoder = JSONEncoder()
                if let encodedData = try? encoder.encode(newTokens) {
                    webDomainTokensData = encodedData
                } else {
                    webDomainTokensData = nil
                }
            } else {
                webDomainTokensData = nil
            }
        }
    }
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()
        
        if let applicationTokens = applicationTokens {
            selectionToDiscourage.applicationTokens = applicationTokens
        }
        
        if let categoryTokens = categoryTokens {
            selectionToDiscourage.categoryTokens = categoryTokens
        }
        
        if let webDomainTokens = webDomainTokens {
            selectionToDiscourage.webDomainTokens = webDomainTokens
        }
        
        // Restore any existing restrictions on app launch
        restoreRestrictionsIfNeeded()
        
        // Extension will handle monitoring when user tries to access apps
    }
    
    class var shared: MyModel {
        return _AppBlockerModel
    }
    
    func setShieldRestrictions() {
        applicationTokens = selectionToDiscourage.applicationTokens
        categoryTokens = selectionToDiscourage.categoryTokens
        webDomainTokens = selectionToDiscourage.webDomainTokens
        
        store.shield.applications = selectionToDiscourage.applicationTokens
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
        store.shield.webDomains = selectionToDiscourage.webDomainTokens
    }
    
    func setShieldRestrictionsFromStorage() {
        store.shield.applications = applicationTokens
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categoryTokens ?? [])
        store.shield.webDomains = webDomainTokens
    }
    
    // Lock apps immediately
    func lockApps() {
        print("🔒 Locking apps immediately...")
        setShieldRestrictions()
        print("🔒 Applied shield restrictions")
        
        // Start daily lock schedule
        startDailyLockSchedule()
        
        // Schedule 12:30 notification for goal incomplete
        scheduleGoalIncompleteNotification()
    }
    
    // Unlock apps (daily goal reached)
    func unlockApps() {
        print("🎯 Daily goal reached! Unlocking apps permanently for today...")
        
        // Clear current restrictions
        store.clearAllSettings()
        print("🔓 Cleared all restrictions")
        
        // Cancel 23:00 notification since goal is reached
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["goalIncomplete"])
        print("⏰ Cancelled 23:00 notification - goal reached!")
        
        // Send congratulations notification
        scheduleGoalReachedNotification()
        
        print("✅ Apps unlocked! Great job on reaching your daily goal!")
    }
    
    // Schedule notification for 23:00 if goal is not reached
    private func scheduleGoalIncompleteNotification() {
        let content = UNMutableNotificationContent()
        content.title = "⏰ The Day is Nearing Its End!"
        content.body = "The goal is still not complete. We will open the applications by tomorrow. 😊"
        content.sound = .default
        content.categoryIdentifier = "GOAL_INCOMPLETE"
        
        // Saat 23:00'da tetikle (gün bitmeden 1 saat önce)
        var dateComponents = DateComponents()
        dateComponents.hour = 23
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "goalIncomplete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule goal incomplete notification: \(error)")
            } else {
                print("⏰ Goal incomplete notification scheduled for 23:00")
            }
        }
    }
    
    // Send congratulations notification for reaching daily goal
    private func scheduleGoalReachedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🎉 Congratulations!"
        content.body = "Your apps are now unlocked for today."
        content.sound = .default
        content.categoryIdentifier = "GOAL_REACHED"
        
        // Send immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "goalReached", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule goal reached notification: \(error)")
            } else {
                print("🎉 Goal reached notification scheduled!")
            }
        }
    }
    
    // Start daily lock schedule (runs every day)
    private func startDailyLockSchedule() {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        
        do {
            try center.startMonitoring(lockScheduleName, during: schedule)
        } catch {
            print("Failed to start daily lock schedule: \(error)")
        }
    }
    
    // Schedule apps to be locked again after 30 minutes
    private func scheduleRelock() {
        let now = Date()
        let relockTime = Calendar.current.date(byAdding: .minute, value: 30, to: now)!
        
        // DeviceActivity seems to have very strict minimum requirements
        // Let's try a much longer interval that starts tomorrow and see if it works
        // We'll use a different approach: schedule for next day briefly to test minimum
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)!
        let startOfTomorrow = Calendar.current.startOfDay(for: tomorrow)
        let endOfInterval = Calendar.current.date(byAdding: .hour, value: 1, to: startOfTomorrow)!
        
        let startComponents = Calendar.current.dateComponents([.hour, .minute], from: startOfTomorrow)
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: endOfInterval)
        
        let schedule = DeviceActivitySchedule(
            intervalStart: startComponents,
            intervalEnd: endComponents,
            repeats: false
        )
        
        do {
            // Stop previous unlock monitoring if exists
            center.stopMonitoring([unlockScheduleName])
            
            // Start new unlock schedule - this is just to test DeviceActivity requirements
            try center.startMonitoring(unlockScheduleName, during: schedule)
            print("🔓 DeviceActivity test scheduled successfully")
            
            // Since DeviceActivity doesn't work for short intervals, 
            // we'll use a hybrid approach for the actual 30-minute relock
            scheduleActualRelock(at: relockTime)
            
        } catch {
            print("❌ Still failed to schedule with DeviceActivity: \(error)")
            print("🔄 Using alternative approach for 30-minute relock")
            scheduleActualRelock(at: relockTime)
        }
    }
    
    private func scheduleActualRelock(at relockTime: Date) {
        // Store the exact time when apps should be locked again
        UserDefaults.standard.set(relockTime, forKey: "scheduledRelockTime")
        UserDefaults.standard.set(true, forKey: "isUnlockActive")
        
        // Schedule local notification with automatic relock
        scheduleRelockNotification(at: relockTime)
        
        print("🔓 Stored relock time: \(relockTime.formatted(date: .omitted, time: .standard))")
        print("🔓 Extension will check unlock status when user tries to access restricted apps")
    }
    
    private func scheduleRelockNotification(at relockTime: Date) {
        let center = UNUserNotificationCenter.current()
        
        // Remove any existing notifications
        center.removePendingNotificationRequests(withIdentifiers: ["relock-notification"])
        
        let content = UNMutableNotificationContent()
        content.title = "WaterBoost"
        content.body = "Your 30-minute break is over. Apps have been automatically restricted."
        content.sound = .default
        
        let timeInterval = relockTime.timeIntervalSinceNow
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: "relock-notification", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            } else {
                print("🔔 Info notification scheduled")
            }
        }
    }
    
    // Setup notification categories (permission already requested in onboarding)
    func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        
        // Create notification category with actions
        let relockAction = UNNotificationAction(
            identifier: "RELOCK_ACTION",
            title: "Lock Apps Now",
            options: [.foreground]
        )
        
        let relockCategory = UNNotificationCategory(
            identifier: "RELOCK_CATEGORY",
            actions: [relockAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Goal reached category (no actions needed)
        let goalReachedCategory = UNNotificationCategory(
            identifier: "GOAL_REACHED",
            actions: [],
            intentIdentifiers: [],
            options: []
        )
        
        // Goal incomplete category (no actions needed)
        let goalIncompleteCategory = UNNotificationCategory(
            identifier: "GOAL_INCOMPLETE",
            actions: [],
            intentIdentifiers: [],
            options: []
        )
        
        center.setNotificationCategories([relockCategory, goalReachedCategory, goalIncompleteCategory])
        print("🔔 Notification categories configured")
    }
    
    // Start continuous monitoring for relock time
    private func startRelockMonitoring() {
        // More frequent checks - every 5 seconds
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            self.checkAndApplyRelockIfNeeded()
            
            // Stop timer if relock is completed
            if !UserDefaults.standard.bool(forKey: "isUnlockActive") {
                timer.invalidate()
                UserDefaults.standard.set(false, forKey: "monitoringIsRunning")
                print("🔄 Monitoring stopped - relock completed")
            }
        }
        
        // Store timer reference
        UserDefaults.standard.set(true, forKey: "relockMonitoringActive")
        print("🔄 Relock monitoring started - checking every 5 seconds")
    }
    
    // Start monitoring only if not already running
    func startMonitoringIfNeeded() {
        guard UserDefaults.standard.bool(forKey: "isUnlockActive") else {
            print("🔄 No active unlock session")
            return
        }
        
        guard !UserDefaults.standard.bool(forKey: "monitoringIsRunning") else {
            print("🔄 Monitoring already running")
            return
        }
        
        startRelockMonitoring()
        UserDefaults.standard.set(true, forKey: "monitoringIsRunning")
    }
    
    private func checkAndApplyRelockIfNeeded() {
        guard let scheduledRelockTime = UserDefaults.standard.object(forKey: "scheduledRelockTime") as? Date else {
            print("🔄 No scheduled relock time found")
            return
        }
        
        let isUnlockActive = UserDefaults.standard.bool(forKey: "isUnlockActive")
        let now = Date()
        let timeRemaining = scheduledRelockTime.timeIntervalSince(now)
        
        print("🔄 Checking relock: Active=\(isUnlockActive), Time remaining=\(Int(timeRemaining/60))m \(Int(timeRemaining.truncatingRemainder(dividingBy: 60)))s")
        
        if isUnlockActive && now >= scheduledRelockTime {
            DispatchQueue.main.async {
                print("🔄 Monitoring detected relock time - applying restrictions now!")
                self.applyStoredRestrictionsFromBackground()
            }
        }
    }
    
    // Stop all monitoring
    func stopMonitoring() {
        center.stopMonitoring([lockScheduleName, unlockScheduleName])
        
        // Clear restrictions
        store.clearAllSettings()
    }
    
    // Restore restrictions if they should be active (called on app launch)
    private func restoreRestrictionsIfNeeded() {
        // Check if we have stored tokens to restore
        guard (applicationTokens != nil || categoryTokens != nil || webDomainTokens != nil) else {
            return
        }
        
        // Check if unlock period has expired
        checkAndApplyScheduledRelock()
        
        // Restart daily monitoring schedule
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        
        do {
            try center.startMonitoring(lockScheduleName, during: schedule)
            print("Restored lock schedule on app launch")
        } catch {
            print("Failed to restore lock schedule: \(error)")
        }
    }
    
    // Check if scheduled relock time has passed and apply restrictions if needed
    func checkAndApplyScheduledRelock() {
        guard let scheduledRelockTime = UserDefaults.standard.object(forKey: "scheduledRelockTime") as? Date else {
            return
        }
        
        let isUnlockActive = UserDefaults.standard.bool(forKey: "isUnlockActive")
        
        if isUnlockActive && Date() >= scheduledRelockTime {
            print("🔒 Relock time reached! Applying restrictions now.")
            setShieldRestrictionsFromStorage()
            
            // Clear the unlock state
            UserDefaults.standard.removeObject(forKey: "scheduledRelockTime")
            UserDefaults.standard.set(false, forKey: "isUnlockActive")
        } else if isUnlockActive {
            let timeRemaining = scheduledRelockTime.timeIntervalSince(Date())
            print("🔓 Still in unlock period. Time remaining: \(Int(timeRemaining/60)) minutes")
        } else {
            // Normal locked state
            setShieldRestrictionsFromStorage()
        }
    }
    
    // Apply stored restrictions from background (called by background task)
    func applyStoredRestrictionsFromBackground() {
        guard let scheduledRelockTime = UserDefaults.standard.object(forKey: "scheduledRelockTime") as? Date else {
            print("🔄 No scheduled relock time found")
            return
        }
        
        let isUnlockActive = UserDefaults.standard.bool(forKey: "isUnlockActive")
        
        if isUnlockActive && Date() >= scheduledRelockTime {
            print("🔒 Background relock: Time reached! Applying restrictions now.")
            setShieldRestrictionsFromStorage()
            
            // Clear the unlock state
            UserDefaults.standard.removeObject(forKey: "scheduledRelockTime")
            UserDefaults.standard.set(false, forKey: "isUnlockActive")
            UserDefaults.standard.set(false, forKey: "monitoringIsRunning")
            
            // Cancel any pending notifications
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["relock-notification"])
            
            print("🔒 Background relock completed - restrictions applied")
        } else {
            print("🔄 Background relock: Not time yet or already locked")
        }
    }
    
    // Check if apps are currently unlocked and handle the state
    func checkUnlockStatus() -> Bool {
        // This is a simple check - in a real implementation you might want to
        // store the unlock state and timestamp in UserDefaults
        let hasActiveRestrictions = store.shield.applications != nil || 
                                   store.shield.applicationCategories != nil ||
                                   store.shield.webDomains != nil
        return !hasActiveRestrictions
    }
}

