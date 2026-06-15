//
//  MainTabbedView.swift
//  WaterBoost
//
//  Created by Banu on 6.07.2025.
//

import Foundation
import SwiftUI

struct MainTabbedView: View {
    
    @State var selectedTab = 0
    let customBlue = Color(red: 134/255, green: 199/255, blue: 237/255)
    private let barHeight: CGFloat = 50   // custom bar yüksekliği

    var body: some View {
        
        ZStack(alignment: .bottom) {
            darkBlue.ignoresSafeArea()
            Text("Detay Sayfası")
                .foregroundColor(darkBlue)
                .navigationBarBackButtonHidden(true)
            
            TabView(selection: $selectedTab) {
                ContentView()
                    .tag(0)
                    .toolbar(.hidden, for: .tabBar)
                ApplicationSelectionPage()
                    .tag(1)
                    .toolbar(.hidden, for: .tabBar)
            }
            .toolbar(.hidden, for: .tabBar)
            
            .contentMargins(.bottom, barHeight + 16, for: .scrollContent) // iOS 17+

                    // 2) Scroll olmayan sayfalar için de güvene al
            .padding(.bottom, barHeight + 16)
            
            ZStack {
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 60)
            .background(customBlue.opacity(0.2))
            .cornerRadius(35)
            .padding(.horizontal, 26)
        }
    }
}

extension MainTabbedView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10){
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 20, height: 20)
            if isActive{
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? .black : .gray)
            }
            Spacer()
        }
        .frame(width: isActive ? .infinity : 60, height: 50)
        .background(isActive ? customBlue.opacity(0.4) : .clear)
        .cornerRadius(30)
    }
}
