//
//  DeviceActivityScreenReport.swift
//  DeviceActivityScreenReport
//
//  Created by Banu on 19.08.2025.
//

// REPORT EXTENSION: Draw Custom Device Activity Report

import SwiftUI
import DeviceActivity

@main
struct WorklogReportExtension: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            return TotalActivityView(activityReport: totalActivity)
        }
        // Add more reports here...
    }
}
