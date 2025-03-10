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

extension LocalTeamLoader {
    public func load() throws -> [Team] {
        if let cache = try store.retrieve(),
           CachePolicy.validate(cache.timestamp,
                                against: currentDate()) {
            return cache.teams.toModels()
        }
        return []
    }
}

public protocol TeamCache {
    func save(_ teams: [Team]) throws
}

extension Array where Element == Team {
    public func toLocal() -> [LocalTeam] {
        return map { LocalTeam(id: $0.id,
                                name: $0.name,
                               logoURL: $0.logoURL)}
    }
}

private extension Array where Element == LocalTeam {
    func toModels() -> [Team] {
        return map { Team(id: $0.id,
                           name: $0.name,
                          logoURL: $0.logoURL)}
    }
}
