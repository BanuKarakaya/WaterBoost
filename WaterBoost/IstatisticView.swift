//
//  IstatisticView.swift
//  WaterBoost
//
//  Created by Banu on 8.07.2025.
//

import SwiftUI
import Charts

struct WaterData: Identifiable {
    let id = UUID()
    let hour: Double
    let waterAmount: Double
}

extension WaterData {
    static let dailyExample: [WaterData] = [
        .init(hour: 8,  waterAmount: 150),
        .init(hour: 10, waterAmount: 200),
        .init(hour: 12, waterAmount: 100),
        .init(hour: 15, waterAmount: 250),
        .init(hour: 18, waterAmount: 180),
        .init(hour: 21, waterAmount: 120),
        .init(hour: 23, waterAmount: 220)
    ]
}

struct IstatisticView: View {
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    let darkChartBlue = Color(red: 4/255, green: 43/255, blue: 66/255)
    let waterData = WaterData.dailyExample
    
    let chartColor = Color.cyan
    let orangeColor = Color(red: 232/255, green: 149/255, blue: 52/255)
    let lightLimeGreen = Color(red: 193/255, green: 255/255, blue: 114/255)
    let pinkLavender = Color(red: 253/255, green: 181/255, blue: 246/255)
    let warmYellow = Color(red: 255/255, green: 187/255, blue: 54/255)

    var linearGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                chartColor.opacity(0.4),
                chartColor.opacity(0.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        ZStack {
            darkBlue.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    Text("Merhaba Banu,")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 16)
                        .padding(.horizontal, 25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack() {
                            Image(systemName: "waterbottle")
                                .fontWeight(.regular)
                                .foregroundColor(.orange)
                                .padding(.top, 70)
                                .padding(.leading, 10)
                            
                            Text("Daily Water Consumption")
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundColor(.orange)
                                .padding(.top, 70)
                                .padding(.leading, 0)
                        }
                        
                        Chart {
                            // Çizgi
                            ForEach(waterData) { data in
                                LineMark(
                                    x: .value("Saat", data.hour),
                                    y: .value("Su (ml)", data.waterAmount)
                                )
                                .interpolationMethod(.cardinal)
                                .foregroundStyle(chartColor)
                                .symbol(by: .value("Tür", "Su"))
                            }
                            
                            // Alan (buğulu)
                            ForEach(waterData) { data in
                                AreaMark(
                                    x: .value("Saat", data.hour),
                                    y: .value("Su (ml)", data.waterAmount)
                                )
                                .interpolationMethod(.cardinal)
                                .foregroundStyle(linearGradient)
                            }
                        }
                        .frame(width: 310, height: 170)
                        .background(darkChartBlue)
                        .chartXScale(domain: waterData.map(\.hour).min()!...waterData.map(\.hour).max()!)
                        .chartLegend(.hidden)
                        .chartYAxis {
                            AxisMarks() { value in
                                AxisGridLine()
                                    .foregroundStyle(Color.white.opacity(0.3))
                                AxisTick()
                                    .foregroundStyle(Color.white.opacity(0.3))
                                AxisValueLabel()
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: waterData.map(\.hour)) { value in
                                AxisGridLine()
                                    .foregroundStyle(Color.white.opacity(0.3))
                                AxisTick()
                                    .foregroundStyle(Color.white.opacity(0.3))
                                if let hour = value.as(Int.self) {
                                    AxisValueLabel("\(hour):00")
                                        .foregroundStyle(Color.white)
                                }
                            }
                        }
                        .aspectRatio(1.0, contentMode: .fit)
                        .padding(.horizontal, 16) // genişlik açısından boşluk
                        .padding(.bottom, 80)
                    }
                    .frame(maxWidth: 340, maxHeight: 240)
                    .background(darkChartBlue)
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack() {
                            Image(systemName: "calendar")
                                .fontWeight(.regular)
                                .foregroundColor(.orange)
                                .padding(.top, 15)
                                .padding(.leading, 10)
                            
                            Text("Weekly Water Consumption")
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundColor(.orange)
                                .padding(.top, 15)
                                .padding(.leading, 0)
                        }
                        
                        Chart {
                                    BarMark(x: .value("Day", "Monday"),
                                            y: .value("Population", 1))
                                    .foregroundStyle(chartColor)
                                    .shadow(color: chartColor.opacity(0.5), radius: 4, x: 0, y: -3)

                                    BarMark(x: .value("Day", "Tuesday"),
                                            y: .value("Population", 2))
                                    .foregroundStyle(lightLimeGreen)
                                    .shadow(color: lightLimeGreen.opacity(0.5), radius: 6, x: 0, y: -3)

                                    BarMark(x: .value("Day", "Wednesday"),
                                            y: .value("Population", 3))
                                    .foregroundStyle(.blue)
                                    .shadow(color: .blue.opacity(0.5), radius: 6, x: 0, y: -3)
                            
                                    BarMark(x: .value("Day", "Thursday"),
                                            y: .value("Population", 4))
                                    .foregroundStyle(pinkLavender)
                                    .shadow(color: pinkLavender.opacity(0.5), radius: 6, x: 0, y: -3)

                                    BarMark(x: .value("Day", "Friday"),
                                            y: .value("Population", 5))
                                    .foregroundStyle(warmYellow)
                                    .shadow(color: warmYellow.opacity(0.5), radius: 6, x: 1, y: -3)

                                    BarMark(x: .value("Day", "Saturday"),
                                            y: .value("Population", 6))
                                    .foregroundStyle(chartColor)
                                    .shadow(color: chartColor.opacity(0.5), radius: 6, x: 0, y: -3)
                            
                                    BarMark(x: .value("Day", "Sunday"),
                                            y: .value("Population", 7))
                                    .foregroundStyle(.blue)
                                    .shadow(color: .blue.opacity(0.5), radius: 6, x: 0, y: -3)
                                }
                                .aspectRatio(1, contentMode: .fit)
                                .chartXAxis {
                                    AxisMarks() { value in
                                        AxisGridLine()
                                            .foregroundStyle(Color.white.opacity(0.3))
                                        AxisTick()
                                            .foregroundStyle(Color.white.opacity(0.3))
                                        AxisValueLabel()
                                            .foregroundStyle(.white.opacity(0.5))
                                    }
                                }
                                .frame(width: 310, height: 280)
                                .padding()
                    }
                    .background(darkChartBlue)
                    .cornerRadius(12)
                    .frame(width: 330, height: 350)
                }
            }
        }
    }
}

#Preview {
    IstatisticView()
}
