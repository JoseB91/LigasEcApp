//
//  PlayerDetailRepository.swift
//  LigasEcApp
//
//  Created by José Briones on 9/7/26.
//

import Foundation

protocol PlayerDetailRepository {
    func loadPlayerDetail() async throws -> PlayerDetail
}

final class PlayerDetailRepositoryImpl: PlayerDetailRepository {
    //private let appLocalLoader: AppLocalLoader
    private let player: Player
    private let httpClient: HTTPClient
    private let configuration: EndpointConfiguration
    //private let remoteLoaders: PlayerRemoteLoaders
    
    init(player: Player,
         httpClient: HTTPClient,
         configuration: EndpointConfiguration) {
        //self.appLocalLoader = appLocalLoader
        self.player = player
        self.httpClient = httpClient
        self.configuration = configuration
        //self.remoteLoaders = remoteLoaders
    }
    
    func loadPlayerDetail() async throws -> PlayerDetail {
        guard let sportId = configuration.sportId, let locale = configuration.locale else {
            throw EndpointConfigurationError.missingFlashLiveValues
        }
        
        let url = PlayerDetailEndpoint.getFlashLive(
            playerId: player.id,
            sportId: sportId,
            locale: locale
        ).url(baseURL: configuration.url)
        
        let (data, response) = try await httpClient.get(from: url, with: configuration.host)
        return try PlayerDetailMapper.map(data, from: response)
    }
}
