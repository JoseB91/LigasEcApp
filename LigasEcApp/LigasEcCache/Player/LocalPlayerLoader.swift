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
        
    public init(store: PlayerStore) {
        self.store = store
    }
}

public protocol PlayerCache {
    func save(_ players: [Player], with id: String) async throws
}

extension LocalPlayerLoader: PlayerCache {
    public func save(_ players: [Player], with id: String) async throws {
        try await store.insert(players.toLocal(), with: id)
    }
}

extension LocalPlayerLoader {
    private struct EmptyData: Error {}
    
    public func load(with id: String, dataSource: DataSource) async throws -> [Player] {
        if let retrievedPlayers = try await store.retrieve(with: id), !retrievedPlayers.isEmpty {
            return retrievedPlayers.toModels(with: dataSource)
        } else {
            throw EmptyData()
        }
    }
}

extension Array where Element == Player {
    public func toLocal() -> [LocalPlayer] {
        return map { LocalPlayer(id: $0.id,
                                name: $0.name,
                                 position: $0.position,
                                 photoURL: $0.photoURL)}
    }
}

private extension Array where Element == LocalPlayer {
    func toModels(with dataSource: DataSource) -> [Player] {
        return map { Player(id: $0.id,
                           name: $0.name,
                            number: 0,
                            position: $0.position,
                            photoURL: $0.photoURL,
                            dataSource: dataSource)}
    }
}
