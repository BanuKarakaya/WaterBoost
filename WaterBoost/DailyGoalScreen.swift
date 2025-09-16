//
//  DailyGoalScreen.swift
//  WaterBoost
//
//  Created by Banu on 18.07.2025.
//

import SwiftUI

struct DailyGoalScreen: View {
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    @State private var dailyGoal: String = ""
    @State private var shouldNavigate = false
    let username = UserDefaults.standard.string(forKey: "username") ?? "No user"
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [darkBlue, Color.blue]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                VStack(spacing: 55) {
                    Image("target")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 250, maxHeight: 250)
                    
                    Text("Hello \(username), how many litres are you aiming for today?")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white.opacity(0.9))
                    
                    TextField("", text: $dailyGoal, prompt: Text("Enter your goal").foregroundColor(darkBlue.opacity(0.4)))
                        .padding()
                        .frame(maxWidth: 250, alignment: .center)
                        .background(.white.opacity(0.8))
                        .keyboardType(.numberPad)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        .padding(-30)
                   
                    Button(action: {
                        UserDefaults.standard.set(dailyGoal, forKey: "dailyGoal")
                        UserDefaults.standard.set(0, forKey: "waterConsumed")
                        
                        // Seçilen uygulamaları kilitle
                        print("🔒 Daily goal set - locking apps...")
                        MyModel.shared.lockApps()
                        
                        shouldNavigate = true
                    }) {
                        HStack(spacing: 8) {
                            Text("Start")
                                .foregroundColor(.white)
                            Image(systemName: "arrow.right.circle")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule().strokeBorder(Color.white, lineWidth: 1.25)
                        )
                    }
                   
                    NavigationLink(destination: MainTabbedView(), isActive: $shouldNavigate) {
                        EmptyView()
                    }
                }
            }
        }
    }
}

#Preview {
    DailyGoalScreen()
}

