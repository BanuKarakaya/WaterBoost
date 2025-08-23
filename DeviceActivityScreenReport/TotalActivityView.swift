//
//  TotalActivityView.swift
//  DeviceActivityScreenReport
//
//  Created by Banu on 19.08.2025.
//

// REPORT EXTENSION: Configure Custom Device Activity Report

import SwiftUI
import Charts

struct TotalActivityView: View {
    var activityReport: ActivityReport
    
    var body: some View {
        VStack {
          
            Text(activityReport.totalDuration.stringFromTimeInterval())
                .font(.subheadline)
            
            // 📊 Chart ekleme yeri
            Chart(activityReport.topAppsWithOthers) { app in
                SectorMark(
                    angle: .value("Süre", app.duration),
                    innerRadius: .ratio(0.5),
                    angularInset: 1.5
                )
                .foregroundStyle(by: .value("App", app.displayName))
            }
            .frame(height: 300)
        }
    }
}

struct ListRow: View {
    var eachApp: AppDeviceActivity
    var body: some View {
        HStack {
            Text(eachApp.displayName)
            Spacer()
            Text(eachApp.id)
            Spacer()
            Text("\(eachApp.numberOfPickups)")
            Spacer()
            Text(String(eachApp.duration.formatted()))
        }
    }
}


import SwiftUI

struct ActivityReport {
    let totalDuration: TimeInterval
    let apps: [AppDeviceActivity]
}

extension ActivityReport {
    var topAppsWithOthers: [AppDeviceActivity] {
        // süreye göre büyükten küçüğe sırala
        let sorted = apps.sorted { $0.duration > $1.duration }
        
        // ilk 5
        let topFive = Array(sorted.prefix(5))
        
        // kalanların toplamı
        let others = sorted.dropFirst(5)
        if !others.isEmpty {
            let totalDuration = others.reduce(0) { $0 + $1.duration }
            let totalPickups = others.reduce(0) { $0 + $1.numberOfPickups }
            
            let otherApp = AppDeviceActivity(
                id: "others",
                displayName: "Diğer",
                duration: totalDuration,
                numberOfPickups: totalPickups
            )
            return topFive + [otherApp]
        }
        
        return topFive
    }
}


struct AppDeviceActivity: Identifiable {
    var id: String
    var displayName: String
    var duration: TimeInterval
    var numberOfPickups: Int
}

extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d",hours,minutes)
    }
}
