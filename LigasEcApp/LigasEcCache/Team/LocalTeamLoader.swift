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

public protocol TeamCache {
    func save(_ teams: [Team], with id: String) throws
}

extension LocalTeamLoader: TeamCache {
    public func save(_ teams: [Team], with id: String) throws {
        //try store.deleteTeams(with: id)
        try store.insert(teams.toLocal(), with: id, timestamp: currentDate())
    }
}

extension LocalTeamLoader {
    private struct EmptyData: Error {}
    
    public func load(with id: String) throws -> [Team] {
        if let cachedTeams = try store.retrieve(with: id),
           CachePolicy.validate(cachedTeams.timestamp,
                                against: currentDate()) {
            let teams = cachedTeams.teams.toModels()
            if teams.isEmpty {
                throw EmptyData()
            } else {
                return teams
            }
        } else {
            throw EmptyData()
        }
    }
}

//extension LocalTeamLoader {
//    private struct InvalidCache: Error {}
//    
//    public func validateCache() throws {
//        do {
//            if let cache = try store.retrieve(), !CachePolicy.validate(cache.timestamp,
//                                                                              against: currentDate()) {
//                throw InvalidCache()
//            }
//        } catch {
//            try store.delete()
//        }
//    }
//}

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
