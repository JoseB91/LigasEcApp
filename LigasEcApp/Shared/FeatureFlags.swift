//
//  FeatureFlags.swift
//  LigasEcApp
//
//  Created by José Briones on 15/3/25.
//

import Foundation

enum FeatureFlagKey: String {
    case serieBEnabled = "SERIE_B_ENABLED"
}

struct FeatureFlags {
    static func isSerieBEnabled() -> Bool {
        guard let value = Bundle.main.object(forInfoDictionaryKey: FeatureFlagKey.serieBEnabled.rawValue) else {
            return true
        }
        if let boolValue = value as? Bool {
            return boolValue
        }
        if let stringValue = value as? String {
            return (stringValue as NSString).boolValue
        }
        return true
    }
    
    static func isEnabled(for league: League) -> Bool {
        if league.id == Constants.serieBIdentifier {
            return isSerieBEnabled()
        }
        return true
    }
}
