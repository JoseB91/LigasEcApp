//
//  LocalPlayerLoader.swift
//  LigasEcApp
//
//  Created by José Briones on 13/3/25.
//

import Foundation

public final class LocalPlayerLoader {
    private let store: PlayerStore
    private let currentDate: () -> Date
        
    public init(store: PlayerStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

public protocol PlayerCache {
    func save(_ players: [Player], with id: String) async throws
}

extension LocalPlayerLoader: PlayerCache {
    public func save(_ players: [Player], with id: String) async throws {
        try await store.insert(players.toLocal(), with: id, timestamp: currentDate())
    }
}

extension LocalPlayerLoader {
    private struct EmptyData: Error {}
    
    public func load(with id: String, dataSource: DataSource) async throws -> [Player] {
        if let retrievedCache = try await store.retrieve(with: id),
           !retrievedCache.players.isEmpty,
           CachePolicy.validate(retrievedCache.timestamp, against: currentDate()) {
            return retrievedCache.players.toModels(with: dataSource)
        } else {
            throw EmptyData()
        }
    }
}

extension Array where Element == Player {
    public func toLocal() -> [LocalPlayer] {
        return map { LocalPlayer(id: $0.id,
                                 name: $0.name,
                                 number: $0.number,
                                 position: $0.position,
                                 flagId: $0.flagId,
                                 nationality: $0.nationality,
                                 photoURL: $0.photoURL)}
    }
}

private extension Array where Element == LocalPlayer {
    func toModels(with dataSource: DataSource) -> [Player] {
        return map { Player(id: $0.id,
                            name: $0.name,
                            number: $0.number,
                            position: $0.position,
                            flagId: $0.flagId,
                            nationality: $0.nationality,
                            photoURL: $0.photoURL,
                            dataSource: dataSource)}
    }
}

//{
//  "DATA": {
//    "ID": "hd6xf1mi",
//    "SHORT_NAME": "Bores E.",
//    "COUNTRY_ID": 68,
//    "COUNTRY_NAME": "Ecuador",
//    "IMAGE_PATH": "https://www.flashscore.com/res/image/data/Gn4jzvzB-OAOwZa9O.png",
//    "NAME": "Eduardo Bores",
//    "BIRTHDAY_TIME": "1035763200",
//    "TYPE_ID": 12,
//    "TYPE_NAME": "guardameta",
//    "PARENT_NAME": "Independiente del Valle",
//    "PMV": "€579k",
//    "PCE": "1861833600",
//    "TEAM_IMAGE": "https://www.flashscore.com/res/image/data/t8nwTpe5-OnCKiY2r.png",
//    "TEAM_NAME": "Independiente del Valle",
//  }
//}
