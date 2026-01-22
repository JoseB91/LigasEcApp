//
//  TeamRepository.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

protocol TeamRepository {
    func loadTeams() async throws -> [Team]
}

final class TeamRepositoryImpl: TeamRepository {
    private let appLocalLoader: AppLocalLoader
    private let league: League
    private let remoteLoaders: TeamRemoteLoaders

    init(appLocalLoader: AppLocalLoader,
         league: League,
         remoteLoaders: TeamRemoteLoaders) {
        self.appLocalLoader = appLocalLoader
        self.league = league
        self.remoteLoaders = remoteLoaders
    }
    
    func loadTeams() async throws -> [Team] {
        do {
            return try await appLocalLoader.localTeamLoader.load(
                with: league.id,
                dataSource: league.dataSource
            )
        } catch {
            guard let remoteLoader = remoteLoaders.loader(for: league.dataSource) else {
                throw error
            }
            
            let teams = try await remoteLoader.loadTeams(for: league)
            
            try? await appLocalLoader.localTeamLoader.save(
                teams,
                with: league.id
            )
            
            return teams
        }
    }
}
