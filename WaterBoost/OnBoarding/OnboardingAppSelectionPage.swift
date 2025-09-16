//
//  OnboardingAppSelectionPage.swift
//  WaterBoost
//
//  Created by Banu on 17.07.2025.
//

import SwiftUI
import FamilyControls

struct OnboardingAppSelectionPage: View {
    @StateObject private var model = MyModel.shared
    @State private var isDiscouragedPresented = false
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [darkBlue, Color.blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                Spacer(minLength: 80)
                
                // Title
                Text("Select Apps to Block")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Choose the apps you want to limit")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // App Selection Button
                Button(action: {
                    isDiscouragedPresented = true
                }) {
                    HStack {
                        Image(systemName: "app.badge")
                            .font(.title2)
                        Text("Select Apps")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    print("✅ Onboarding tamamlandı! Apps will be locked when daily goal is set.")
                    
                    // Onboarding'i bitir - kilitleme daily goal'da olacak
                    UserDefaults.standard.set(false, forKey: "isOnboarding")
                }) {
                    HStack(spacing: 8) {
                        Text("Continue")
                            .foregroundColor(.white)
                        Image(systemName: "arrow.right.circle")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        Capsule().strokeBorder(Color.white, lineWidth: 1.25)
                    )
                }
                .padding(.bottom, 80)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: $model.selectionToDiscourage)
    }
}

#Preview {
    OnboardingAppSelectionPage()
}
