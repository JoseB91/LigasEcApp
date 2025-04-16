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
        
    public init(store: TeamStore) {
        self.store = store
    }
}

public protocol TeamCache {
    func save(_ teams: [Team], with id: String) async throws
}

extension LocalTeamLoader: TeamCache {
    public func save(_ teams: [Team], with id: String) async throws {
        try await store.insert(teams.toLocal(), with: id)
    }
}

extension LocalTeamLoader {
    private struct EmptyData: Error {}
    
    public func load(with id: String, dataSource: DataSource) async throws -> [Team] {
        if let retrievedTeams = try await store.retrieve(with: id), !retrievedTeams.isEmpty {
            return retrievedTeams.toModels(with: dataSource)
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
