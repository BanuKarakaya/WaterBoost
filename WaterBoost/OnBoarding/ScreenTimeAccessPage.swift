//
//  ScreenTimeAccessPage.swift
//  WaterBoost
//
//  Created by Banu on 6.08.2025.
//

import SwiftUI
import FamilyControls



struct ScreenTimeAccessPage: View {
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    @State private var shouldNavigate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [darkBlue, Color.blue]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                VStack(spacing: 55) {
                    
                    Image("screentime")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 250, maxHeight: 250)
                    
                    Text("We need to access your screen time to move forward with this process.")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        .padding()
               
                    Button(action: {
                        Task {
                            do {
                                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                                print("Permission granted")
                                shouldNavigate = true
                            } catch {
                                print("Permission denied: \(error)")
                            }
                        }
                    }) {
                        HStack {
                            Text("Connect")
                        }
                        .frame(width: 250, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        
                    }
                    NavigationLink(destination: NotificationPermissionPage()
                        .navigationBarBackButtonHidden(true)      // Back butonunu gizler
                        .toolbar(.hidden, for: .navigationBar),
                    isActive: $shouldNavigate) {
                        EmptyView()
                    }
                }
            }
        }
    }
}

#Preview {
    ScreenTimeAccessPage()
}

