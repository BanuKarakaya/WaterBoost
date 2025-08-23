//
//  ListView.swift
//  WaterBoost
//
//  Created by Banu on 30.03.2025.
//

import SwiftUI
import ConfettiSwiftUI

struct ListView: View {
    @State private var counter = 0
        
        var body: some View {
            VStack {
                Button(action: {
                    counter += 1
                }) {
                    Text("🎃")
                        .font(.system(size: 50))
                }
            }
            .confettiCannon(trigger: $counter, num: 160, confettiSize: 8) // 👈 Container'a eklendi
        }
}

#Preview {
    ListView()
}
