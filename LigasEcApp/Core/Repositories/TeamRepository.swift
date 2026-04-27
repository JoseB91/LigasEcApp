//
//  TeamRepository.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

enum CacheBackedRepositoryLoader {
    static func load<Model, Loader>(
        dataSource: DataSource,
        loadLocal: () async throws -> [Model],
        resolveRemoteLoader: (DataSource) -> Loader?,
        loadRemote: (Loader) async throws -> [Model],
        save: ([Model]) async -> Void
    ) async throws -> [Model] {
        do {
            return try await loadLocal()
        } catch {
            guard let remoteLoader = resolveRemoteLoader(dataSource) else {
                throw error
            }

            let models = try await loadRemote(remoteLoader)
            await save(models)
            return models
        }
    }
}

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
        try await CacheBackedRepositoryLoader.load(
            dataSource: league.dataSource,
            loadLocal: {
                try await appLocalLoader.localTeamLoader.load(
                    with: league.id,
                    dataSource: league.dataSource
                )
            },
            resolveRemoteLoader: { dataSource in
                remoteLoaders.loader(for: dataSource)
            },
            loadRemote: { remoteLoader in
                try await remoteLoader.loadTeams(for: league)
            },
            save: { teams in
                try? await appLocalLoader.localTeamLoader.save(
                    teams,
                    with: league.id
                )
            }
        )
    }
}
