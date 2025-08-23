//
//  OnboardingCardView.swift
//  WaterBoost
//
//  Created by Banu on 17.07.2025.
//

import SwiftUI

struct OnboardingCardView: View {
    var onboarding: OnboardingModel
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Image(onboarding.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 8, x: 6, y: 8)
                    .scaleEffect(isAnimating ? 1.0 : 0.6)
                
                Text(onboarding.title)
                    .foregroundColor(Color.white)
                    .font(.title)
                    .frame(maxWidth: 450, alignment: .center)
                    .multilineTextAlignment(.center)
                    .fontWeight(.heavy)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2)
                
                Text(onboarding.headline)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: 480)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                  isAnimating = true
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: onboarding.gradientColors), startPoint: .top, endPoint: .bottom))
        //.cornerRadius(20)
        //.padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingCardView(onboarding: onboardingData[0])
}
