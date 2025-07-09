//
//  HomeView.swift
//  WaterBoost
//
//  Created by Banu on 30.03.2025.
//

import SwiftUI

struct HomeView: View {
    
    let darkBlue = Color(red: 0/255, green: 27/255, blue: 43/255)
    let shadowBlue = Color(red: 7/255, green: 100/255, blue: 155/255)
    let peachColor = Color(red: 7/255, green: 70/255, blue: 107/255)
    let lightBlue = Color(red: 183 / 255, green: 222 / 255, blue: 250 / 255)
    let motionManager = MotionManager()
    @State private var percent = 20.0
    
    var body: some View {
        ZStack {
            darkBlue
                .ignoresSafeArea() // Safe area'yı da kaplasın
            
            VStack {
                // Tarih Metni
                Text("Tuesday, Jun 1")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
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
                GravityAnimation(percent: percent).environmentObject(motionManager)
                
                Spacer() // Alt tarafta boşluk bırak
                
                HStack(spacing: 15) {
                    Button(action: {
                        withAnimation {
                            percent = min(percent + 20, 100) // 100'ü geçmesin
                        }
                    }) {
                           Text("200 ml")
                             .foregroundColor(lightBlue)
                             .padding()
                             .background(
                               RoundedRectangle(cornerRadius: 10)
                                 .stroke(lightBlue, lineWidth: 1)
                             )
                         }
                    .shadow(color: .white, radius: 15, y: 1)
                    
                    Button(action: {
                        withAnimation {
                            percent = min(percent + 20, 100) // 100'ü geçmesin
                        }
                    }) {
                           Text("300 ml")
                             .foregroundColor(lightBlue)
                             .padding()
                             .background(
                               RoundedRectangle(cornerRadius: 10)
                                 .stroke(lightBlue, lineWidth: 1)
                             )
                         }
                    .shadow(color: .white, radius: 15, y: 1)
                    
                    Button(action: {
                        withAnimation {
                            percent = min(percent + 20, 100) // 100'ü geçmesin
                        }
                    }) {
                           Text("500 ml")
                             .foregroundColor(lightBlue)
                             .padding()
                             .background(
                               RoundedRectangle(cornerRadius: 10)
                                 .stroke(lightBlue, lineWidth: 1)
                             )
                         }
                    .shadow(color: .white, radius: 15, y: 1)
                }
                
                .padding(.bottom, 60)
            }
            .padding(.horizontal, 30) // Kenarlardan içeri al
        }
    }
}

#Preview {
    HomeView()
}
