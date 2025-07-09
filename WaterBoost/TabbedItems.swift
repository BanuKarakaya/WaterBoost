//
//  TabbedItems.swift
//  WaterBoost
//
//  Created by Banu on 6.07.2025.
//

import Foundation

enum TabbedItems: Int, CaseIterable {
    case home = 0
    case istatistics
    case list
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .istatistics:
            return "Statistics"
        case .list:
            return "List"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "home-icon"
        case .istatistics:
            return "statistics-icon"
        case .list:
            return "list-icon"
        }
    }
}
