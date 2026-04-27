//
//  LocalTeamLoader.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation

public final class LocalTeamLoader {
    private let store: TeamStore
    private let currentDate: () -> Date
        
    public init(store: TeamStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

public protocol TeamCache {
    func save(_ teams: [Team], with id: String) async throws
}

extension LocalTeamLoader: TeamCache {
    public func save(_ teams: [Team], with id: String) async throws {
        try await store.insert(teams.toLocal(), with: id, timestamp: currentDate())
    }
}

extension LocalTeamLoader {
    private struct EmptyData: Error {}
    
    public func load(with id: String, dataSource: DataSource) async throws -> [Team] {
        if let retrievedCache = try await store.retrieve(with: id),
           !retrievedCache.teams.isEmpty,
           CachePolicy.validate(retrievedCache.timestamp, against: currentDate()) {
            return retrievedCache.teams.toModels(with: dataSource)
        } else {
            throw EmptyData()
        }
    }
}

extension Array where Element == Team {
    public func toLocal() -> [LocalTeam] {
        return map { LocalTeam(id: $0.id,
                               name: $0.name,
                               logoURL: $0.logoURL)}
    }
}

private extension Array where Element == LocalTeam {
    func toModels(with dataSource: DataSource) -> [Team] {
        return map { Team(id: $0.id,
                          name: $0.name,
                          logoURL: $0.logoURL,
                          dataSource: dataSource)}
    }
}
