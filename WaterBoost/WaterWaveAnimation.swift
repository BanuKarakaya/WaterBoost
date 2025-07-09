//
//  WaterWaveAnimation.swift
//  WaterBoost
//
//  Created by Banu on 5.04.2025.
//

import SwiftUI

struct WaterWaveAnimation: View {
    
    var percent: Double
    @State private var waveOffset = Angle(degrees: 0)
    let lightBlue = Color(red: 134/255, green: 199/255, blue: 237/255)
    
    var body: some View {
        ZStack {
            Wave(offSet: Angle(degrees: waveOffset.degrees), percent: percent)
                .fill(lightBlue)
                .ignoresSafeArea(.all)
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                self.waveOffset = Angle(degrees: 360)
            }
        }
    }
}

struct Wave: Shape {
   
    var offSet: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offSet.degrees }
        set { offSet = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let lowestWave = 0.02
        let hishestWave = 1.00
        
        let newPercent = lowestWave + (hishestWave - lowestWave) * (percent / 100)
        let waveHeight = 0.015 * rect.height
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)
        
        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

#Preview {
    WaterWaveAnimation(percent: 10.0)
}
