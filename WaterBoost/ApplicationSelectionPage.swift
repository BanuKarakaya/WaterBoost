//
//  ApplicationSelectionPage.swift
//  WaterBoost
//
//  Created by Banu on 7.08.2025.
//

import SwiftUI

struct NotificationPermissionPage: View {
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    @State private var shouldNavigate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [darkBlue, Color.blue]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                VStack(spacing: 55) {
                    Image("notifications")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 250, maxHeight: 250)
                    
                    Text("We'd like to send you a notification to remind you to drink water. Would you allow us to do so?")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        .padding()
               
                    Button(action: {
                        
                    }) {
                        HStack {
                            Text("Allow")
                        }
                        .frame(width: 250, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        
                    }
                    NavigationLink(destination: ListView(), isActive: $shouldNavigate) {
                        EmptyView()
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationPermissionPage()
}


