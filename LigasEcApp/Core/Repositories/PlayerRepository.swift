//
//  PlayerRepository.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

protocol PlayerRepository {
    func loadPlayers() async throws -> [Player]
}

final class PlayerRepositoryImpl: PlayerRepository {
    private let appLocalLoader: AppLocalLoader
    private let team: Team
    private let remoteLoaders: PlayerRemoteLoaders

    init(appLocalLoader: AppLocalLoader,
         team: Team,
         remoteLoaders: PlayerRemoteLoaders) {
        self.appLocalLoader = appLocalLoader
        self.team = team
        self.remoteLoaders = remoteLoaders
    }
    
    func loadPlayers() async throws -> [Player] {
        try await CacheBackedRepositoryLoader.load(
            dataSource: team.dataSource,
            loadLocal: {
                try await appLocalLoader.localPlayerLoader.load(
                    with: team.id,
                    dataSource: team.dataSource
                )
            },
            resolveRemoteLoader: { dataSource in
                remoteLoaders.loader(for: dataSource)
            },
            loadRemote: { remoteLoader in
                try await remoteLoader.loadPlayers(for: team)
            },
            save: { players in
                try? await appLocalLoader.localPlayerLoader.save(
                    players,
                    with: team.id
                )
            }
        )
    }
}
