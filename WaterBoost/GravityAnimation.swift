//
//  GravityAnimation.swift
//  WaterBoost
//
//  Created by Banu on 3.04.2025.
//

import CoreMotion
import SwiftUI

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    
    var fx: CGFloat = 0
    var fy: CGFloat = 0
    var fz: CGFloat = 0
    
    var dx: CGFloat = 0
    var dy: CGFloat = 0
    var dz: CGFloat = 0
    
    init() {
        motionManager.startDeviceMotionUpdates(to: .main) { data, error in
            guard let newData = data?.gravity else { return }
            
            self.dx = newData.x
            self.dy = newData.y
            self.dz = newData.z
            
            self.fx = CGFloat(newData.x)
            self.fy = CGFloat(newData.y)
            self.fz = CGFloat(newData.z)
            
            self.objectWillChange.send()
            
        }
    }
    
    func shutDown() {
        motionManager.stopDeviceMotionUpdates()
    }
}

struct GravityAnimation: View {
    @EnvironmentObject var motion: MotionManager
    var percent: Double
    
    var body: some View {
        ZStack {
            StraightImageView(percent: percent)
        }
    }
}

struct StraightImageView: View {
    @EnvironmentObject var motion: MotionManager
    let lightBlue = Color(red: 183 / 255, green: 222 / 255, blue: 250 / 255)
    var percent: Double
    
    var body: some View {
        ZStack {
            WaterWaveAnimation(percent: percent)
                .frame(width: 250, height: 250) // Daire boyutu
                .foregroundColor(Color(red: 183 / 255, green: 222 / 255, blue: 250 / 255))
                .clipShape(Circle()) // Sınırlandır
                .overlay( // İsteğe bağlı daire çerçevesi
                     Circle()
                        .stroke(lightBlue, lineWidth: 6)
                )
                .rotationEffect(.init(radians: atan2(motion.dx, motion.dy) + CGFloat.pi))
        }
    }
}

#Preview {
    GravityAnimation(percent: 10)
        .environmentObject(MotionManager())
}
