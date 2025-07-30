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
    private let httpClient: HTTPClient
    private let appLocalLoader: AppLocalLoader
    private let teamRepositoryParams: TeamRepositoryParams

    init(httpClient: HTTPClient, appLocalLoader: AppLocalLoader, teamRepositoryParams: TeamRepositoryParams) {
        self.httpClient = httpClient
        self.appLocalLoader = appLocalLoader
        self.teamRepositoryParams = teamRepositoryParams
    }
    
    func loadTeams() async throws -> [Team] {
        if teamRepositoryParams.league.dataSource == .flashLive {
            do {
                return try await appLocalLoader.localTeamLoader.load(with: teamRepositoryParams.league.id, dataSource: .flashLive)
            } catch {
                let url = TeamEndpoint.getFlashLive(
                    seasonId: teamRepositoryParams.league.id,
                    standingType: "overall",
                    locale: "es_MX",
                    tournamentStageId: "OO37de6i")
                    .url(baseURL: teamRepositoryParams.flashLiveEndpointConfiguration.url
                    )
                
                let (data, response) = try await httpClient.get(
                    from: url,
                    with: teamRepositoryParams.flashLiveEndpointConfiguration.host
                )
                
                let teams = try TeamMapper.map(data, from: response, with: .flashLive)
                
                try? await appLocalLoader.localTeamLoader.save(
                    teams,
                    with: teamRepositoryParams.league.id
                )
                
                return teams
            }
        } else {
            do {
                return try await appLocalLoader.localTeamLoader.load(
                    with: teamRepositoryParams.league.id,
                    dataSource: .transferMarket
                )
            } catch {
                let url = TeamEndpoint.getTransferMarket(
                    id: teamRepositoryParams.league.id,
                    domain: "es")
                    .url(baseURL: teamRepositoryParams.transferMarketEndpointConfiguration.url)
                
                let (data, response) = try await httpClient.get(
                    from: url,
                    with: teamRepositoryParams.transferMarketEndpointConfiguration.host
                )
                
                let teams = try TeamMapper.map(data, from: response, with: .transferMarket)
                
                try? await appLocalLoader.localTeamLoader.save(
                    teams,
                    with: teamRepositoryParams.league.id
                )
                
                return teams
            }
        }
    }
}
