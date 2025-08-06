//
//  DrinkWaterIntent.swift
//  WaterBoost
//
//  Created by Banu on 6.08.2025.
//

import AppIntents

struct DrinkWaterIntent: AppIntent {
    static var title: LocalizedStringResource = "Hedefi Tamamladım"

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(true, forKey: "shouldShowAlert")
        return .result()
    }
}
