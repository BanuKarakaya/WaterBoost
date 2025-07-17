//
//  OnboardingModel.swift
//  WaterBoost
//
//  Created by Banu on 17.07.2025.
//

import Foundation
import SwiftUI

struct OnboardingModel: Identifiable {
  var id = UUID()
  var title: String
  var headline: String
  var image: String
  var gradientColors: Color
}
