//
//  OnboardingView.swift
//  WaterBoost
//
//  Created by Banu on 17.07.2025.
//

import SwiftUI

struct OnboardingView: View {
    var onboardings: [OnboardingModel] = onboardingData
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    
    var body: some View {
          TabView {
            ForEach(onboardings[0...3]) { item in
                OnboardingCardView(onboarding: item)
            }
          }
          .tabViewStyle(PageTabViewStyle())
          .padding(.vertical, 20)
          .background(darkBlue)
    }
}

#Preview {
    OnboardingView()
}
