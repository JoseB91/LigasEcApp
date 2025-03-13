//
//  LocalPlayerLoader.swift
//  LigasEcApp
//
//  Created by José Briones on 13/3/25.
//

import Foundation
import LigasEcAPI

public final class LocalPlayerLoader {
    private let store: PlayerStore
    private let currentDate: () -> Date
        
    public init(store: PlayerStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

public protocol PlayerCache {
    func save(_ players: [Player], with id: String) throws
}

extension LocalPlayerLoader: PlayerCache {
    public func save(_ players: [Player], with id: String) throws {
        //try store.deleteTeams(with: id)
        try store.insert(players.toLocal(), with: id, timestamp: currentDate())
    }
}

extension LocalPlayerLoader {
    private struct EmptyData: Error {}
    
    public func load(with id: String) throws -> [Player] {
        if let cachedPlayers = try store.retrieve(with: id),
           CachePolicy.validate(cachedPlayers.timestamp,
                                against: currentDate()) {
            let players = cachedPlayers.players.toModels()
            if players.isEmpty {
                throw EmptyData()
            } else {
                return players
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

extension Array where Element == Player {
    public func toLocal() -> [LocalPlayer] {
        return map { LocalPlayer(id: $0.id,
                                name: $0.name,
                                 position: $0.position,
                                 photoURL: $0.photoURL)}
    }
}

private extension Array where Element == LocalPlayer {
    func toModels() -> [Player] {
        return map { Player(id: $0.id,
                           name: $0.name,
                            number: 0,
                            position: $0.position,
                            photoURL: $0.photoURL)}
    }
}
