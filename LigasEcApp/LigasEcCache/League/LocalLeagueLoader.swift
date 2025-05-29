//
//  LocalLeagueLoader.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import Foundation

public final class LocalLeagueLoader {
    private let store: LeagueStore
    private let currentDate: () -> Date
        
    public init(store: LeagueStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

public protocol LeagueCache {
    func save(_ teams: [League]) async throws
}

extension LocalLeagueLoader: LeagueCache {
    public func save(_ leagues: [League]) async throws {
        do {
            try await store.insert(leagues.toLocal(), timestamp: currentDate())
        } catch {
            try await store.deleteCache()
        }
    }
}

extension LocalLeagueLoader {
    private struct InvalidCache: Error {}
    
    public func validateCache() async throws {
        do {
            if let cache = try await store.retrieve(), !CachePolicy.validate(cache.timestamp,
                                                                              against: currentDate()) {
                throw InvalidCache()
            }
        } catch {
            try await store.deleteCache()
        }
    }
}

extension Array where Element == League {
    public func toLocal() -> [LocalLeague] {
        return map { LocalLeague(id: $0.id,
                                 name: $0.name,
                                 logoURL: $0.logoURL)}
    }
}
