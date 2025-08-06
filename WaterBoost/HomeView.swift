//
//  HomeView.swift
//  WaterBoost
//
//  Created by Banu on 30.03.2025.
//

import SwiftUI

struct HomeView: View {

    let darkBlue = Color(red: 0 / 255, green: 27 / 255, blue: 43 / 255)
    let shadowBlue = Color(red: 7 / 255, green: 100 / 255, blue: 155 / 255)
    let lightBlue = Color(red: 183 / 255, green: 222 / 255, blue: 250 / 255)
    
    let motionManager = MotionManager()
    @State private var percent: Double = 0.0
    @State private var waterConsumed: Int = 0
    @State private var showGoalReachedAlert = false
    @State private var hasShownGoalAlert = false
    @State private var showRedirectAlert = false
    let dailyGoal = Int(UserDefaults.standard.string(forKey: "dailyGoal") ?? "2000") ?? 2000
    
    var body: some View {
        ZStack {
            darkBlue.ignoresSafeArea()
            
            VStack {
                Text(getTodayFormatted())
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                HStack(spacing: 30) {
                    waterInfoView(amount: waterConsumed, title: "Water Consumed")
                    
                    Divider()
                        .frame(width: 1, height: 50)
                        .background(Color.white)
                    
                    waterInfoView(amount: dailyGoal, title: "Daily goal")
                }
                .padding(.vertical, 20)
                
                GravityAnimation(percent: percent)
                    .environmentObject(motionManager)
                
                Spacer()
                
                HStack(spacing: 15) {
                    waterButton(amount: 200)
                    waterButton(amount: 300)
                    waterButton(amount: 500)
                }
                .padding(.bottom, 60)
            }
            .padding(.horizontal, 30)
        }
    }
    
    func waterInfoView(amount: Int, title: String) -> some View {
        VStack {
            Text("\(amount) ml")
                .fontWeight(.heavy)
                .foregroundColor(.white)
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(Color(red: 0.716, green: 0.847, blue: 0.913))
        }
    }
    
    func waterButton(amount: Int) -> some View {
        Button(action: {
            withAnimation {
                let percentIncrease = Double(amount * 100) / Double(dailyGoal)
                percent = min(percent + percentIncrease, 100)
                waterConsumed += amount
            }
        }) {
            Text("\(amount) ml")
                .foregroundColor(lightBlue)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lightBlue, lineWidth: 1)
                )
        }
        .shadow(color: .white, radius: 15, y: 1)
    }
    
    func getTodayFormatted() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

#Preview {
    HomeView()
}
