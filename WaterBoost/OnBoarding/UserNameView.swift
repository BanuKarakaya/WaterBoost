//
//  UserNameView.swift
//  WaterBoost
//
//  Created by Banu on 17.07.2025.
//

import SwiftUI

struct UserNameView1: View {
    var body: some View {
        NavigationStack {
            UserNameView()
        }
    }
}

struct UserNameView: View {
   
   @State private var isAnimating: Bool = false
   let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
   @State private var username: String = ""
   @State private var shouldNavigate = false
   @AppStorage("isOnboarding") var isOnboarding: Bool?
   
   var body: some View {
           ZStack {
               VStack(spacing: 20) {
                   Image("name")
                       .resizable()
                       .scaledToFit()
                       .frame(maxWidth: 250, maxHeight: 250)
                       .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 8, x: 6, y: 8)
                       .scaleEffect(isAnimating ? 1.0 : 0.6)
                   
                   Text("Can you share your name with us?")
                       .foregroundColor(Color.white)
                       .font(.title2)
                       .frame(maxWidth: 450, alignment: .center)
                       .multilineTextAlignment(.center)
                       .fontWeight(.bold)
                       .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2)
                   
                   TextField("Enter Your Name", text: $username)
                       .padding()
                       .frame(maxWidth: 250, alignment: .center)
                       .background(.white)
                       .foregroundStyle(darkBlue)
                       .clipShape(RoundedRectangle(cornerRadius: 7))
                   
                   Button(action: {
                       UserDefaults.standard.set(username, forKey: "username")
                       shouldNavigate = true
                   }) {
                       HStack(spacing: 8) {
                           Text("Start")
                           
                           Image(systemName: "arrow.right.circle")
                               .imageScale(.large)
                       }
                       .padding(.horizontal, 16)
                       .padding(.vertical, 10)
                       .background(
                           Capsule().strokeBorder(Color.white, lineWidth: 1.25)
                       )
                   }
                   .accentColor(Color.white)
               }
               
               NavigationLink(destination: ScreenTimeAccessPage(), isActive: $shouldNavigate) {
                   EmptyView()
               }
           }
           .onAppear {
               withAnimation(.easeOut(duration: 0.5)) {
                   isAnimating = true
               }
               
               NotificationCenter.default.addObserver(forName: .navigateTrigger, object: nil, queue: .main) { _ in
                   isOnboarding = false
               }
           }
           .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
           .background(LinearGradient(gradient: Gradient(colors: [darkBlue, Color.blue]), startPoint: .top, endPoint: .bottom))
           //.cornerRadius(20)
           //.padding(.horizontal, 20)
       }
   }

#Preview {
   UserNameView()
}


