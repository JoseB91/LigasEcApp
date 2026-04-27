//
//  RemoteLoaders.swift
//  LigasEcApp
//
//  Created by José Briones on 18/3/25.
//

import Foundation

// MARK: - Team Remote Loaders

protocol RemoteTeamLoader {
    func loadTeams(for league: League) async throws -> [Team]
}

struct TeamRemoteLoaders {
    private let loaders: [DataSource: any RemoteTeamLoader]
    
    init(loaders: [DataSource: any RemoteTeamLoader]) {
        self.loaders = loaders
    }
    
    func loader(for dataSource: DataSource) -> (any RemoteTeamLoader)? {
        loaders[dataSource]
    }
}

final class FlashLiveTeamRemoteLoader: RemoteTeamLoader {
    
    private let httpClient: HTTPClient
    private let configuration: EndpointConfiguration
    
    init(httpClient: HTTPClient,
         configuration: EndpointConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
    }
    
    func loadTeams(for league: League) async throws -> [Team] {
        guard
            let standingType = configuration.standingType,
            let locale = configuration.locale,
            let tournamentStageId = configuration.tournamentStageId
        else {
            throw EndpointConfigurationError.missingFlashLiveValues
        }

        let url = TeamEndpoint.getFlashLive(
            seasonId: league.id,
            standingType: standingType,
            locale: locale,
            tournamentStageId: tournamentStageId
        ).url(baseURL: configuration.url)
        
        let (data, response) = try await httpClient.get(from: url, with: configuration.host)
        return try TeamMapper.map(data, from: response, with: .flashLive)
    }
}

final class TransferMarketTeamRemoteLoader: RemoteTeamLoader {
    
    private let httpClient: HTTPClient
    private let configuration: EndpointConfiguration
    
    init(httpClient: HTTPClient,
         configuration: EndpointConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
    }
    
    func loadTeams(for league: League) async throws -> [Team] {
        guard let domain = configuration.domain else {
            throw EndpointConfigurationError.missingTransferMarketValues
        }

        let url = TeamEndpoint.getTransferMarket(
            id: league.id,
            domain: domain
        ).url(baseURL: configuration.url)
        
        let (data, response) = try await httpClient.get(from: url, with: configuration.host)
        return try TeamMapper.map(data, from: response, with: .transferMarket)
    }
}

// MARK: - Player Remote Loaders

protocol RemotePlayerLoader {
    func loadPlayers(for team: Team) async throws -> [Player]
}

struct PlayerRemoteLoaders {
    private let loaders: [DataSource: any RemotePlayerLoader]
    
    init(loaders: [DataSource: any RemotePlayerLoader]) {
        self.loaders = loaders
    }
    
    func loader(for dataSource: DataSource) -> (any RemotePlayerLoader)? {
        loaders[dataSource]
    }
}

final class FlashLivePlayerRemoteLoader: RemotePlayerLoader {
    
    private let httpClient: URLSessionHTTPClient
    private let configuration: EndpointConfiguration
    
    init(httpClient: URLSessionHTTPClient,
         configuration: EndpointConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
    }
    
    func loadPlayers(for team: Team) async throws -> [Player] {
        guard
            let sportId = configuration.sportId,
            let locale = configuration.locale
        else {
            throw EndpointConfigurationError.missingFlashLiveValues
        }

        let url = PlayerEndpoint.getFlashLive(
            sportId: sportId,
            locale: locale,
            teamId: team.id
        ).url(baseURL: configuration.url)
        
        let (data, response) = try await httpClient.get(from: url, with: configuration.host)
        return try PlayerMapper.map(data, from: response, with: .flashLive)
    }
}

final class TransferMarketPlayerRemoteLoader: RemotePlayerLoader {
    
    private let httpClient: URLSessionHTTPClient
    private let configuration: EndpointConfiguration
    
    init(httpClient: URLSessionHTTPClient,
         configuration: EndpointConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
    }
    
    func loadPlayers(for team: Team) async throws -> [Player] {
        guard let domain = configuration.domain else {
            throw EndpointConfigurationError.missingTransferMarketValues
        }

        let url = PlayerEndpoint.getTransferMarket(
            id: team.id,
            domain: domain
        ).url(baseURL: configuration.url)
        
        let (data, response) = try await httpClient.get(from: url, with: configuration.host)
        return try PlayerMapper.map(data, from: response, with: .transferMarket)
    }
}

enum EndpointConfigurationError: Error {
    case missingFlashLiveValues
    case missingTransferMarketValues
}
