//
//  LocalTeamLoader.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation
import LigasEcAPI

public final class LocalTeamLoader {
    private let store: TeamStore
    private let currentDate: () -> Date
        
    public init(store: TeamStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalTeamLoader: TeamCache {
    public func save(_ teams: [Team]) throws {
        try store.delete()
        try store.insert(teams.toLocal(), timestamp: currentDate())
    }
    
}

public protocol TeamCache {
    func save(_ teams: [Team]) throws
}
