//
//  CachePolicy.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation

struct CachePolicy {
    private init() {}
    
    private static let calendar = Calendar.current
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
