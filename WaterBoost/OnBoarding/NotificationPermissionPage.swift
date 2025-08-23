//
//  NotificationPermissionPage.swift
//  WaterBoost
//
//  Created by Banu on 7.08.2025.
//

import SwiftUI
import UserNotifications

struct NotificationPermissionPage: View {
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    
    var body: some View {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [darkBlue, Color.blue]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                VStack(spacing: 35) {
                    Image("notifications")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 250, maxHeight: 250)
                        .padding(.top, -30)
                    
                    
                    Text("We'd like to send you a notification to remind you to drink water. Would you allow us to do so?")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        .padding()
               
                    Button(action: {
                        requestNotificationPermission()
                    }) {
                        HStack {
                            Text("Allow")
                        }
                        .frame(width: 250, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }
            .navigationBarBackButtonHidden(true)      // Back butonunu gizler
            .toolbar(.hidden, for: .navigationBar)
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("İzin alınırken hata oluştu: \(error.localizedDescription)")
            } else {
                print("İzin verildi mi? \(granted)")
                NotificationCenter.default.post(name: .navigateTrigger, object: nil)
            }
        }
    }
}

#Preview {
    NotificationPermissionPage()
}

