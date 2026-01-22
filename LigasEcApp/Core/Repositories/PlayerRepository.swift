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
        do {
            return try await appLocalLoader.localPlayerLoader.load(
                with: team.id,
                dataSource: team.dataSource
            )
        } catch {
            guard let remoteLoader = remoteLoaders.loader(for: team.dataSource) else {
                throw error
            }
            
            let players = try await remoteLoader.loadPlayers(for: team)
            
            try? await appLocalLoader.localPlayerLoader.save(
                players,
                with: team.id
            )
            
            return players
        }
    }
}
