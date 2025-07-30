//
//  Composer.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import CoreData
import os

class Composer {
    private let flashLiveEndpointConfiguration: EndpointConfiguration
    private let transferMarketEndpointConfiguration: EndpointConfiguration
    private let httpClient: URLSessionHTTPClient
    private let appLocalLoader: AppLocalLoader

    init(flashLiveEndpointConfiguration: EndpointConfiguration,
         transferMarketEndpointConfiguration: EndpointConfiguration,
         httpClient: URLSessionHTTPClient,
         appLocalLoader: AppLocalLoader) {
        self.flashLiveEndpointConfiguration = flashLiveEndpointConfiguration
        self.transferMarketEndpointConfiguration = transferMarketEndpointConfiguration
        self.httpClient = httpClient
        self.appLocalLoader = appLocalLoader
    }
    
    static func makeComposer() -> Composer {
        
        let flashLiveEndpointConfiguration = EndpointConfiguration(
            url: URL(string: "https://flashlive-sports.p.rapidapi.com/v1/")!,
            host: "flashlive-sports.p.rapidapi.com"
        )
        
        let transferMarketEndpointConfiguration = EndpointConfiguration(
            url: URL(string:"https://transfermarket.p.rapidapi.com/")!,
            host: "transfermarket.p.rapidapi.com"
        )
        
        let httpClient = makeHTTPClient()
        
        let store = makeStore()
        
        let localLeagueLoader = LocalLeagueLoader(store: store, currentDate: Date.init)
        let localTeamLoader = LocalTeamLoader(store: store)
        let localPlayerLoader = LocalPlayerLoader(store: store)
        let localImageLoader = LocalImageLoader(store: store)

        let appLocalLoader = AppLocalLoader(localLeagueLoader: localLeagueLoader,
                                            localTeamLoader: localTeamLoader,
                                            localPlayerLoader: localPlayerLoader,
                                            localImageLoader: localImageLoader)
        
        return Composer(flashLiveEndpointConfiguration: flashLiveEndpointConfiguration,
                        transferMarketEndpointConfiguration: transferMarketEndpointConfiguration,
                        httpClient: httpClient,
                        appLocalLoader: appLocalLoader)
    }
    
    private static func makeHTTPClient() -> URLSessionHTTPClient {
        var apiKey = ""
        
        do {
            apiKey = try KeychainManager.retrieveAPIKey()
        } catch KeychainError.itemNotFound {
            if let envAPIKey = ProcessInfo.processInfo.environment["API_KEY"], !envAPIKey.isEmpty {
                apiKey = envAPIKey
                try? KeychainManager.saveAPIKey(apiKey)
            } else if let bundleAPIKey = Bundle.main.infoDictionary?["API_KEY"] as? String,
               !bundleAPIKey.isEmpty {
                apiKey = bundleAPIKey
                try? KeychainManager.saveAPIKey(apiKey)
            } else {
                Logger.composer.error("No API key found in Keychain or Bundle")
            }
        } catch {
            Logger.composer.error("Error retrieving API key : \(error.localizedDescription)")
        }
        
        return URLSessionHTTPClient(
            session: URLSession(configuration: .ephemeral),
            apiKey: apiKey)
    }
    
    private static func makeStore() -> LeagueStore & ImageStore & TeamStore & PlayerStore {
        do {
            return try CoreDataLigasEcStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("ligas-ec-store.sqlite"))
        } catch {
            // Add logger
            return InMemoryStore()
        }
    }
    
    func composeLeagueViewModel() -> LeagueViewModel {
        let repository = LeagueRepositoryImpl(httpClient: httpClient,
                                              appLocalLoader: appLocalLoader)
        
        return LeagueViewModel(repository: repository)
    }
    
    func composeTeamViewModel(for league: League) -> TeamViewModel {
        let teamRepositoryParams = TeamRepositoryParams(
            league: league,
            flashLiveEndpointConfiguration: flashLiveEndpointConfiguration,
            transferMarketEndpointConfiguration: transferMarketEndpointConfiguration
        )
        
        let repository = TeamRepositoryImpl(httpClient: httpClient,
                                            appLocalLoader: appLocalLoader,
                                            teamRepositoryParams: teamRepositoryParams)
        return TeamViewModel(repository: repository)
    }
    
    func composePlayerViewModel(for team: Team) -> PlayerViewModel {
        let playerLoader: () async throws -> [Player] = {
            [flashLiveEndpointConfiguration, transferMarketEndpointConfiguration,httpClient, appLocalLoader] in
            
            if team.dataSource == .FlashLive {
                do {
                    return try await appLocalLoader.localPlayerLoader.load(with: team.id, dataSource: .FlashLive)
                } catch {
                    let url = PlayerEndpoint.getFlashLive(sportId: 1,
                                                          locale: "es_MX",
                                                          teamId: team.id).url(baseURL: flashLiveEndpointConfiguration.url)
                    
                    let (data, response) = try await httpClient.get(from: url, with: flashLiveEndpointConfiguration.host)
                    
                    let players = try PlayerMapper.map(data, from: response, with: .FlashLive)
                    
                    do {
                        try await appLocalLoader.localPlayerLoader.save(players, with: team.id)
                    } catch {
                        Logger.composer.error("Couldn't save FlashLive teams to cache")
                    }
                    
                    return players
                }
            } else {
                do {
                    return try await appLocalLoader.localPlayerLoader.load(with: team.id, dataSource: .TransferMarket)
                } catch {
                    let url = PlayerEndpoint.getTransferMarket(id: team.id,
                                                               domain: "es").url(baseURL: transferMarketEndpointConfiguration.url)
                    
                    let (data, response) = try await httpClient.get(from: url, with: transferMarketEndpointConfiguration.host)
                    
                    let players = try PlayerMapper.map(data, from: response, with: .TransferMarket)
                    
                    do {
                        try await appLocalLoader.localPlayerLoader.save(players, with: team.id)
                    } catch {
                        Logger.composer.error("Couldn't save TransferMarket players to cache")
                    }
                    
                    return players
                }
            }
        }
        return PlayerViewModel(playerLoader: playerLoader)
    }
    
    func composeImageView(with url: URL, on table: Table) -> ImageView {
        let repository = ImageRepositoryImpl(url: url,
                                             table: table,
                                             httpClient: httpClient,
                                             appLocalLoader: appLocalLoader)

        let imageViewModel = ImageViewModel(repository: repository)

        return ImageView(imageViewModel: imageViewModel)
    }
    
    func validateCache() async throws {
        try await appLocalLoader.localLeagueLoader.validateCache()
    }
}

struct EndpointConfiguration {
    let url: URL
    let host: String
}

struct AppLocalLoader {
    let localLeagueLoader: LocalLeagueLoader
    let localTeamLoader: LocalTeamLoader
    let localPlayerLoader: LocalPlayerLoader
    let localImageLoader: LocalImageLoader
}

struct TeamRepositoryParams {
    let league: League
    let flashLiveEndpointConfiguration: EndpointConfiguration
    let transferMarketEndpointConfiguration: EndpointConfiguration
}

extension Logger {
    static let composer = Logger(subsystem: "com.joseB91.LatinCoaches", category: "Composer")
}
