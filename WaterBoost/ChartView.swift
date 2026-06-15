//
//  ChartView.swift
//  WaterBoost
//
//  Created by Banu on 20.08.2025.
//


import SwiftUI
import DeviceActivity

struct ChartView: View {

    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
               of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad])
    )

    var body: some View {
        ZStack {
            DeviceActivityReport(context, filter: filter)
        }
        .frame(height: 400)
    }
}

struct STProgressView: View {
    var body: some View {
        ProgressView {
            Text("Loading")
        }
    }
}
