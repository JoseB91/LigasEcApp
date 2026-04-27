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
    private let standingType: String
    private let locale: String
    private let tournamentStageId: String
    
    init(httpClient: HTTPClient,
         configuration: EndpointConfiguration,
         standingType: String = "overall",
         locale: String = "es_MX",
         tournamentStageId: String = "x2nVXCWr") {
        self.httpClient = httpClient
        self.configuration = configuration
        self.standingType = standingType
        self.locale = locale
        self.tournamentStageId = tournamentStageId
    }
    
    func loadTeams(for league: League) async throws -> [Team] {
        let url = TeamEndpoint.getFlashLive(
            seasonId: league.id,
            standingType: configuration.standingType ?? standingType,
            locale: configuration.locale ?? locale,
            tournamentStageId: configuration.tournamentStageId ?? tournamentStageId
        ).url(baseURL: configuration.url)
        
        let (data, response) = try await httpClient.get(from: url, with: configuration.host)
        return try TeamMapper.map(data, from: response, with: .flashLive)
    }
}

final class TransferMarketTeamRemoteLoader: RemoteTeamLoader {
    
    private let httpClient: HTTPClient
    private let configuration: EndpointConfiguration
    private let domain: String
    
    init(httpClient: HTTPClient,
         configuration: EndpointConfiguration,
         domain: String = "es") {
        self.httpClient = httpClient
        self.configuration = configuration
        self.domain = domain
    }
    
    func loadTeams(for league: League) async throws -> [Team] {
        let url = TeamEndpoint.getTransferMarket(
            id: league.id,
            domain: configuration.domain ?? domain
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
    private let sportId: Int
    private let locale: String
    
    init(httpClient: URLSessionHTTPClient,
         configuration: EndpointConfiguration,
         sportId: Int = 1,
         locale: String = "es_MX") {
        self.httpClient = httpClient
        self.configuration = configuration
        self.sportId = sportId
        self.locale = locale
    }
    
    func loadPlayers(for team: Team) async throws -> [Player] {
        let url = PlayerEndpoint.getFlashLive(
            sportId: configuration.sportId ?? sportId,
            locale: configuration.locale ?? locale,
            teamId: team.id
        ).url(baseURL: configuration.url)
        
        let (data, response) = try await httpClient.get(from: url, with: configuration.host)
        return try PlayerMapper.map(data, from: response, with: .flashLive)
    }
}

final class TransferMarketPlayerRemoteLoader: RemotePlayerLoader {
    
    private let httpClient: URLSessionHTTPClient
    private let configuration: EndpointConfiguration
    private let domain: String
    
    init(httpClient: URLSessionHTTPClient,
         configuration: EndpointConfiguration,
         domain: String = "es") {
        self.httpClient = httpClient
        self.configuration = configuration
        self.domain = domain
    }
    
    func loadPlayers(for team: Team) async throws -> [Player] {
        let url = PlayerEndpoint.getTransferMarket(
            id: team.id,
            domain: domain
        ).url(baseURL: configuration.url)
        
        let (data, response) = try await httpClient.get(from: url, with: configuration.host)
        return try PlayerMapper.map(data, from: response, with: .transferMarket)
    }
}
