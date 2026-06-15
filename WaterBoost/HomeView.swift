//
//  HomeView.swift
//  WaterBoost
//
//  Created by Banu on 30.03.2025.
//

import SwiftUI
import ConfettiSwiftUI

struct HomeView: View {

    let darkBlue = Color(red: 0 / 255, green: 27 / 255, blue: 43 / 255)
    let shadowBlue = Color(red: 7 / 255, green: 100 / 255, blue: 155 / 255)
    let lightBlue = Color(red: 183 / 255, green: 222 / 255, blue: 250 / 255)
    
    let motionManager = MotionManager()
    @State private var percent: Double = 0.0
    @State private var showGoalReachedAlert = false
    @State private var hasShownGoalAlert = false
    @State private var showRedirectAlert = false
    let dailyGoal = Int(UserDefaults.standard.string(forKey: "dailyGoal") ?? "2000") ?? 2000
    @State private var waterConsumed = Int(UserDefaults.standard.string(forKey: "waterConsumed") ?? "0") ?? 0
    @State private var hasReachedGoal: Bool = false

        init() {
            _hasReachedGoal = State(initialValue: UserDefaults.standard.bool(forKey: HomeView.todayKey()))
        }
  // sadece ilk defa konfeti için
    @State private var confettiTrigger = 0
    
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
                
                GravityAnimation(percent: (Double(waterConsumed) / Double(dailyGoal)) * 100)
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
        .confettiCannon(trigger: $confettiTrigger, num: 160, confettiSize: 8)
        .onAppear {
            // Check if relock time has passed every time HomeView appears
            MyModel.shared.checkAndApplyScheduledRelock()
            
            // Start monitoring if unlock is active and not already running
            if UserDefaults.standard.bool(forKey: "isUnlockActive") {
                MyModel.shared.startMonitoringIfNeeded()
            }
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
                var percent = (Double(waterConsumed) / Double(dailyGoal)) * 100
                percent = min(percent + percentIncrease, 100)
                waterConsumed += amount
            }
            UserDefaults.standard.set(waterConsumed, forKey: "waterConsumed")
            NotificationCenter.default.post(name: .triggerFunction, object: nil)
            
            if waterConsumed >= dailyGoal && !hasReachedGoal {
                hasReachedGoal = true
                UserDefaults.standard.set(true, forKey: HomeView.todayKey())
                confettiTrigger += 1   // konfeti patlat
               
            } else if waterConsumed >= dailyGoal {
                // Daily goal'a ulaşıldı - blokları kaldır
                print("🎯 Daily goal reached! Unlocking apps...")
                MyModel.shared.unlockApps()
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
    
    static func todayKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // sadece günü ayı yılı sakla
        return "goalReached_\(formatter.string(from: Date()))"
    }
}

#Preview {
    HomeView()
}
