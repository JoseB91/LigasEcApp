//
//  Composer.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import Foundation
import SwiftUI
import CoreData
import os
import SharedAPI
import LigasEcAPI

class Composer {
    private let flashLiveEndpointConfiguration: EndpointConfiguration
    private let transferMarketEndpointConfiguration: EndpointConfiguration
    private let httpClient: URLSessionHTTPClient
    private let appLocalLoader: AppLocalLoader

    //let logger = Logger(subsystem: "com.joseB91.LatinCoaches", category: "main")

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
            if let bundleAPIKey = Bundle.main.infoDictionary?["API_KEY"] as? String,
               !bundleAPIKey.isEmpty {
                apiKey = bundleAPIKey
                
                try? KeychainManager.saveAPIKey(apiKey)
                // TODO: Log this --> print("Default API key saved to Keychain")
            } else {
                // TODO: Log this --> print("No API key found in Keychain or Bundle")
                // In a real app, you might want to show an error or prompt for the key
            }
        } catch {
            // TODO: Log this --> print("Error retrieving API key: \(error.localizedDescription)")
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
        let leagueLoader: () async throws -> [League] = { [appLocalLoader] in
            
            let hardcodedLeagues = [
                League(id: "IaFDigtm",
                       name: "LigaPro Serie A",
                       logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!,
                       dataSource: .FlashLive),
                League(id: "EC2L",
                       name: "LigaPro Serie B",
                       logoURL: URL(string: "https://www.flashscore.com/res/image/data/2g15S2DO-GdicJTVi.png")!,
                       dataSource: .TransferMarket)
            ]
                        
            do {
                try await appLocalLoader.localLeagueLoader.save(hardcodedLeagues)
            } catch {
                print(error)
            }
            
            return hardcodedLeagues
        }
        
        return LeagueViewModel(leagueLoader: leagueLoader)
    }
    
    func composeTeamViewModel(for league: League) -> TeamViewModel {
        let teamLoader: () async throws -> [Team] = {
            [flashLiveEndpointConfiguration, transferMarketEndpointConfiguration, httpClient, appLocalLoader] in
            
            if league.dataSource == .FlashLive {
                do {
                    return try await appLocalLoader.localTeamLoader.load(with: league.id, dataSource: .FlashLive)
                } catch {
                    let url = TeamEndpoint.getFlashLive(seasonId: league.id,
                                               standingType: "overall", // TODO: Manage constants
                                               locale: "es_MX", // TODO: Get locale
                                                        tournamentStageId: "OO37de6i").url(baseURL: flashLiveEndpointConfiguration.url)
                    
                    let (data, response) = try await httpClient.get(from: url, with: flashLiveEndpointConfiguration.host)
                                        
                    let teams = try TeamMapper.map(data, from: response, with: .FlashLive)
                    
                    do {
                        try await appLocalLoader.localTeamLoader.save(teams, with: league.id)
                    } catch {
                        print(error)
                    }
                    
                    return teams
                }
            } else {
                do {
                    return try await appLocalLoader.localTeamLoader.load(with: league.id, dataSource: .TransferMarket)
                } catch {
                    let url = TeamEndpoint.getTransferMarket(id: league.id,
                                                             domain: "es").url(baseURL: transferMarketEndpointConfiguration.url)
                    
                    let (data, response) = try await httpClient.get(from: url, with: transferMarketEndpointConfiguration.host)
                    
                    let teams = try TeamMapper.map(data, from: response, with: .TransferMarket)
                    
                    do {
                        try await appLocalLoader.localTeamLoader.save(teams, with: league.id)
                    } catch {
                        print(error)
                    }
                    
                    return teams
                }
            }
        }
        return TeamViewModel(teamLoader: teamLoader)
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
                        print(error)
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
                        print(error)
                    }
                    
                    return players
                }
            }
        }
        return PlayerViewModel(playerLoader: playerLoader)
    }
    
    func composeImageView(with url: URL, on table: Table) -> ImageView {

        let imageLoader: () async throws -> Data = { [httpClient, appLocalLoader] in
            
            do {
                return try await appLocalLoader.localImageLoader.loadImageData(from: url, on: table)
            } catch {
                let (data, response) = try await httpClient.get(from: url)
                
                let imageData = try ImageMapper.map(data, from: response)
                
                do {
                    try await appLocalLoader.localImageLoader.save(imageData, for: url, on: table)
                } catch {
                    print(error)
                }
                
                return imageData
            }
        }
        let imageViewModel = ImageViewModel(imageLoader: imageLoader,
                                            imageTransformer: UIImage.init)
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
