//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitorExtension
//
//  Created by Banu on 11.08.2025.
//

import DeviceActivity
import ManagedSettings
import Foundation
import FamilyControls

// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    let store = ManagedSettingsStore()
    
    // Shared UserDefaults to communicate with main app
    let sharedDefaults = UserDefaults(suiteName: "group.com.banu.waterboost")
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        let now = Date().formatted(date: .omitted, time: .standard)
        print("🔵 Extension: intervalDidStart for '\(activity)' at \(now)")
        
        if activity == DeviceActivityName("unlock") {
            // This is when the relock time starts - immediately apply restrictions
            print("🔒 Extension: RELOCK TIME REACHED - Applying restrictions now!")
            applyStoredRestrictions()
        }
        
        if activity == DeviceActivityName("lock") {
            // Daily lock schedule started - check if unlock period expired
            print("🔒 Extension: Daily lock schedule started - checking unlock status")
            checkAndApplyRelockIfNeeded()
        }
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        let now = Date().formatted(date: .omitted, time: .standard)
        print("🔴 Extension: intervalDidEnd for '\(activity)' at \(now)")
        
        if activity == DeviceActivityName("unlock") {
            // This should also apply restrictions to be safe
            print("🔒 Extension: Unlock interval ended - ensuring restrictions are applied")
            applyStoredRestrictions()
        }
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
        print("Extension: intervalWillEndWarning for \(activity)")
        
        if activity == DeviceActivityName("unlock") {
            // Warn user that unlock period is about to end
            print("Extension: Unlock period ending soon")
        }
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
    
    // Apply stored restrictions from shared UserDefaults
    private func applyStoredRestrictions() {
        guard let sharedDefaults = sharedDefaults else {
            print("Extension: Failed to access shared UserDefaults")
            return
        }
        
        // Load stored tokens from UserDefaults
        var applicationTokens: Set<ApplicationToken>?
        var categoryTokens: Set<ActivityCategoryToken>?
        var webDomainTokens: Set<WebDomainToken>?
        
        if let appData = sharedDefaults.data(forKey: "applicationTokensData") {
            let decoder = JSONDecoder()
            applicationTokens = try? decoder.decode(Set<ApplicationToken>.self, from: appData)
        }
        
        if let catData = sharedDefaults.data(forKey: "categoryTokensData") {
            let decoder = JSONDecoder()
            categoryTokens = try? decoder.decode(Set<ActivityCategoryToken>.self, from: catData)
        }
        
        if let webData = sharedDefaults.data(forKey: "webDomainTokensData") {
            let decoder = JSONDecoder()
            webDomainTokens = try? decoder.decode(Set<WebDomainToken>.self, from: webData)
        }
        
        // Apply restrictions
        store.shield.applications = applicationTokens
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categoryTokens ?? [])
        store.shield.webDomains = webDomainTokens
        
        print("Extension: Applied restrictions - Apps: \(applicationTokens?.count ?? 0), Categories: \(categoryTokens?.count ?? 0), Domains: \(webDomainTokens?.count ?? 0)")
    }
    
    // Check if unlock period has expired and apply restrictions if needed
    private func checkAndApplyRelockIfNeeded() {
        guard let sharedDefaults = sharedDefaults else {
            print("Extension: Failed to access shared UserDefaults")
            return
        }
        
        guard let scheduledRelockTime = sharedDefaults.object(forKey: "scheduledRelockTime") as? Date else {
            print("Extension: No scheduled relock time found")
            applyStoredRestrictions() // Apply normal restrictions
            return
        }
        
        let isUnlockActive = sharedDefaults.bool(forKey: "isUnlockActive")
        let now = Date()
        
        print("Extension: Checking unlock status - Active: \(isUnlockActive), Scheduled: \(scheduledRelockTime.formatted(date: .omitted, time: .standard))")
        
        if isUnlockActive && now >= scheduledRelockTime {
            print("🔒 Extension: Unlock period expired! User trying to access restricted app - Applying restrictions now!")
            
            // Clear unlock state
            sharedDefaults.removeObject(forKey: "scheduledRelockTime")
            sharedDefaults.set(false, forKey: "isUnlockActive")
            
            // Apply restrictions immediately
            applyStoredRestrictions()
            
            print("🔒 Extension: User will see restriction screen when trying to access app!")
        } else if isUnlockActive {
            let timeRemaining = scheduledRelockTime.timeIntervalSince(now)
            print("Extension: Still in unlock period - Time remaining: \(Int(timeRemaining/60)) minutes")
            // Don't apply restrictions, user can still access apps
        } else {
            // Normal state - apply restrictions
            applyStoredRestrictions()
        }
    }
}
