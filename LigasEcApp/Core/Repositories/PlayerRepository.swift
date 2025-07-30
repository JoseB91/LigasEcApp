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
    private let httpClient: URLSessionHTTPClient
    private let appLocalLoader: AppLocalLoader
    private let playerRepositoryParams: PlayerRepositoryParams

    init(httpClient: URLSessionHTTPClient, appLocalLoader: AppLocalLoader, playerRepositoryParams: PlayerRepositoryParams) {
        self.httpClient = httpClient
        self.appLocalLoader = appLocalLoader
        self.playerRepositoryParams = playerRepositoryParams
    }
    
    func loadPlayers() async throws -> [Player] {
        if playerRepositoryParams.team.dataSource == .FlashLive {
            do {
                return try await appLocalLoader.localPlayerLoader.load(
                    with: playerRepositoryParams.team.id,
                    dataSource: .FlashLive
                )
            } catch {
                let url = PlayerEndpoint.getFlashLive(
                    sportId: 1,
                    locale: "es_MX",
                    teamId: playerRepositoryParams.team.id)
                    .url(baseURL: playerRepositoryParams.flashLiveEndpointConfiguration.url)
                
                let (data, response) = try await httpClient.get(
                    from: url,
                    with: playerRepositoryParams.flashLiveEndpointConfiguration.host
                )
                
                let players = try PlayerMapper.map(data, from: response, with: .FlashLive)
                
                try? await appLocalLoader.localPlayerLoader.save(
                    players,
                    with: playerRepositoryParams.team.id
                )
                
                return players
            }
        } else {
            do {
                return try await appLocalLoader.localPlayerLoader.load(
                    with: playerRepositoryParams.team.id,
                    dataSource: .TransferMarket
                )
            } catch {
                let url = PlayerEndpoint.getTransferMarket(
                    id: playerRepositoryParams.team.id,
                    domain: "es")
                    .url(baseURL: playerRepositoryParams.transferMarketEndpointConfiguration.url)
                
                let (data, response) = try await httpClient.get(
                    from: url,
                    with: playerRepositoryParams.transferMarketEndpointConfiguration.host
                )
                
                let players = try PlayerMapper.map(data, from: response, with: .TransferMarket)
                
                try? await appLocalLoader.localPlayerLoader.save(
                    players,
                    with: playerRepositoryParams.team.id)
                
                return players
            }
        }
    }
}
