//
//  LocalLeagueLoader.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import Foundation
import LigasEcAPI

public final class LocalLeagueLoader {
    private let store: LeagueStore
    private let currentDate: () -> Date
        
    public init(store: LeagueStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

public protocol LeagueCache {
    func save(_ teams: [League]) throws
}

extension LocalLeagueLoader: LeagueCache {
    public func save(_ leagues: [League]) throws {
        do {
            try store.insert(leagues.toLocal(), timestamp: currentDate())
        } catch {
            try store.deleteCache()
        }
    }
}

extension LocalLeagueLoader {
    private struct InvalidCache: Error {}
    
    public func validateCache() throws {
        do {
            if let cache = try store.retrieve(), !CachePolicy.validate(cache.timestamp,
                                                                              against: currentDate()) {
                throw InvalidCache()
            }
        } catch {
            try store.deleteCache()
        }
    }
}

extension Array where Element == League {
    public func toLocal() -> [LocalLeague] {
        return map { LocalLeague(id: $0.id,
                                 stageId: $0.stageId,
                                 name: $0.name,
                                 logoURL: $0.logoURL)}
    }
}
