//
//  ApplicationSelectionPage.swift
//  WaterBoost
//
//  Created by Banu on 7.08.2025.
//

import SwiftUI
import FamilyControls
import DeviceActivity

struct ApplicationSelectionPage: View {
    @StateObject private var model = MyModel.shared
    @State private var isDiscouragedPresented = false
    @State private var isLocked = false
    @State private var unlockTimeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    @State private var pulseAnimation = false
    @State private var shouldNavigate = false
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    let color = Color(red: 6/255, green: 62/255, blue: 96/255)
    
    var body: some View {
        NavigationView {
            ZStack {
                darkBlue.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer(minLength: 10)
                        
                        Text("Hello Banu,")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        // App Selection Card
                        VStack(spacing: 16) {
                            HStack {
                                Text("📱")
                                    .font(.title)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Selected Apps")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text("\(model.selectionToDiscourage.applicationTokens.count + model.selectionToDiscourage.categoryTokens.count) apps blocked")
                                        .font(.subheadline)
                                        .foregroundColor(.white).opacity(0.5)
                                }
                                
                                Spacer()
                                
                                Text("\(model.selectionToDiscourage.applicationTokens.count + model.selectionToDiscourage.categoryTokens.count)")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                            }
                            
                            Button {
                                isDiscouragedPresented = true
                            } label: {
                                HStack {
                                    Text("➕")
                                        .font(.title3)
                                    Text("Choose Apps")
                                        .font(.headline)
                                        .foregroundColor(color)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white).opacity(0.9)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(color)
                                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
                        )
                        .padding(.horizontal, 20)
                        
                        // Action Button
                        Button {
                            lockApps()
                        } label: {
                            HStack(spacing: 12) {
                                Text("🔒")
                                    .font(.title2)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Lock Apps Now")
                                        .font(.headline)
                                    Text("Block selected apps")
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.red)
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer()
                        
                        Text("Your Screen Time Distribution")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        ChartView()
                            .padding(.horizontal, 20)
                            .padding(.top, -20)
                        
                        .buttonStyle(.plain)
                    }
                }
            }
            .background(Color(.systemGray6).opacity(0.3))
            .navigationBarTitleDisplayMode(.inline)
        }
        .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: $model.selectionToDiscourage)
        .onAppear {
            pulseAnimation = true
            checkLockStatus()
            NotificationCenter.default.addObserver(forName: .triggerFunction, object: nil, queue: .main) { _ in
                unlockApps()
            }
        }
    }
    
    private func checkLockStatus() {
        // Check if apps are currently locked
        let hasActiveRestrictions = ((model.store.shield.applications?.isEmpty) == nil) ||
        ((model.store.shield.webDomains?.isEmpty) == nil)
        isLocked = hasActiveRestrictions
    }
    
    private func lockApps() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            model.lockApps()
            isLocked = true
            stopUnlockTimer()
        }
        shouldNavigate = true
    }
    
    private func unlockApps() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            model.unlockApps()
            isLocked = false
            startUnlockTimer()
        }
        print("çalıştı")
    }
    
    private func startUnlockTimer() {
        unlockTimeRemaining = 2 * 60
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if unlockTimeRemaining > 0 {
                unlockTimeRemaining -= 1
            } else {
                stopUnlockTimer()
                
                DispatchQueue.main.async {
                    lockApps()
                }
            }
        }
    }
    
    private func stopUnlockTimer() {
        timer?.invalidate()
        timer = nil
        unlockTimeRemaining = 0
    }
    
    private func formattedTime(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval) ?? "00:00"
    }
}

#Preview {
    ApplicationSelectionPage()
}


