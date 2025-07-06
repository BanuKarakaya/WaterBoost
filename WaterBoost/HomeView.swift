//
//  HomeView.swift
//  WaterBoost
//
//  Created by Banu on 30.03.2025.
//

import SwiftUI

struct HomeView: View {
    
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    let motionManager = MotionManager()
    
    var body: some View {
        ZStack {
            darkBlue
                .ignoresSafeArea() // Safe area'yı da kaplasın
            
            VStack {
                // Tarih Metni
                Text("Tuesday, Jun 1")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 128/255, green: 128/255, blue: 128/255))
                    .padding(.top, 20)
                
                // Üst Bilgiler (1100 ml - Divider - 2250 ml)
                HStack(spacing: 30) { // Gereksiz Spacer'ları kaldır
                    VStack {
                        Text("1100 ml")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        Text("Left to drink")
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.716, green: 0.847, blue: 0.913))
                    }
                    
                    Divider()
                        .frame(width: 1, height: 50) // Çizginin genişliği ve yüksekliği
                        .background(Color.white)
                    
                    VStack {
                        Text("2250 ml")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        Text("Daily goal")
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.716, green: 0.847, blue: 0.913))
                    }
                }
                .padding(.vertical, 20) // Yukarıdan ve aşağıdan boşluk bırak
                
                // Ana Görsel
                GravityAnimation().environmentObject(motionManager)
                
                Spacer() // Alt tarafta boşluk bırak
            }
            .padding(.horizontal, 30) // Kenarlardan içeri al
        }
    }
}

#Preview {
    HomeView()
}
