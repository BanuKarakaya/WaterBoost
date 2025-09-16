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
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    VStack(spacing: 30) {
                        Spacer(minLength: 50)
                        
                        // Image - klavye açıkken küçülsün
                        Image("name")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                maxWidth: keyboardHeight > 0 ? 150 : 250,
                                maxHeight: keyboardHeight > 0 ? 150 : 250
                            )
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 8, x: 6, y: 8)
                            .scaleEffect(isAnimating ? 1.0 : 0.6)
                            .animation(.easeInOut(duration: 0.3), value: keyboardHeight)
                        
                        // Text - klavye açıkken font küçülsün
                        Text("Can you share your name with us?")
                            .foregroundColor(Color.white)
                            .font(keyboardHeight > 0 ? .title3 : .title2)
                            .frame(maxWidth: 450, alignment: .center)
                            .multilineTextAlignment(.center)
                            .fontWeight(.bold)
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2)
                            .animation(.easeInOut(duration: 0.3), value: keyboardHeight)
                        
                        // TextField
                        TextField("Enter Your Name", text: $username)
                            .padding()
                            .frame(maxWidth: 250, alignment: .center)
                            .background(.white)
                            .foregroundStyle(darkBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .focused($isTextFieldFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                isTextFieldFocused = false
                            }
                        
                        // Button
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
                        
                        // Klavye için spacer
                        Spacer(minLength: keyboardHeight > 0 ? 100 : 50)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .padding(.bottom, keyboardHeight > 0 ? keyboardHeight - 100 : 0)
                .animation(.easeInOut(duration: 0.3), value: keyboardHeight)
                .onTapGesture {
                    isTextFieldFocused = false
                }
            }
            
            NavigationLink(destination: NotificationPermissionPage(), isActive: $shouldNavigate) {
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
            
            // Keyboard observers
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        keyboardHeight = keyboardFrame.height
                    }
                }
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    keyboardHeight = 0
                }
            }
        }
        .onDisappear {
            // Clean up observers
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
