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
    private let baseURL: URL
    private let httpClient: URLSessionHTTPClient
    private let localLeagueLoader: LocalLeagueLoader
    private let localImageLoader: LocalImageLoader
    private let localTeamLoader: LocalTeamLoader
    private let localPlayerLoader: LocalPlayerLoader

    //let logger = Logger(subsystem: "com.joseB91.LatinCoaches", category: "main")

    init(baseURL: URL,
         httpClient: URLSessionHTTPClient,
         localLeagueLoader: LocalLeagueLoader,
         localImageLoader: LocalImageLoader,
         localTeamLoader: LocalTeamLoader,
         localPlayerLoader: LocalPlayerLoader) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localLeagueLoader = localLeagueLoader
        self.localImageLoader = localImageLoader
        self.localTeamLoader = localTeamLoader
        self.localPlayerLoader = localPlayerLoader
    }
    
    static func makeComposer() -> Composer {
        let baseURL = URL(string: "https://flashlive-sports.p.rapidapi.com/v1/")!
        let httpClient = makeHTTPClient()
        let store = makeStore()
        let localLeagueLoader = LocalLeagueLoader(store: store, currentDate: Date.init)
        let localImageLoader = LocalImageLoader(store: store)
        let localTeamLoader = LocalTeamLoader(store: store)
        let localPlayerLoader = LocalPlayerLoader(store: store)
        
        return Composer(baseURL: baseURL,
                        httpClient: httpClient,
                        localLeagueLoader: localLeagueLoader,
                        localImageLoader: localImageLoader,
                        localTeamLoader: localTeamLoader,
                        localPlayerLoader: localPlayerLoader)
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
        let leagueLoader: () async throws -> [League] = { [localLeagueLoader] in
            
            let hardcodedLeagues = [
                League(id: "IaFDigtm",
                       stageId: "OO37de6i",
                       name: "LigaPro Serie A",
                       logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!),
                League(id: "0O4IjDeg",
                       stageId: "Au6JggjA",
                       name: "LigaPro Serie B",
                       logoURL: URL(string: "https://www.flashscore.com/res/image/data/2g15S2DO-GdicJTVi.png")!)
            ]
            
            Task {
                localLeagueLoader.saveIgnoringResult(hardcodedLeagues)
            }
            
            return hardcodedLeagues
        }
        
        return LeagueViewModel(leagueLoader: leagueLoader)
    }
    
    func composeTeamViewModel(for league: League) -> TeamViewModel {
        let teamLoader: () async throws -> [Team] = { [httpClient, localTeamLoader] in
            
            do {
                return try localTeamLoader.load(with: league.id)
            } catch {
                let url = TeamEndpoint.get(seasonId: league.id,
                                           standingType: "overall", // TODO: Manage constants
                                           locale: "es_MX", // TODO: Get locale
                                           tournamentStageId: league.stageId).url(baseURL: self.baseURL)
                let (data, response) = try await httpClient.get(from: url)
                
                let teams = try TeamMapper.map(data, from: response)
                
                Task {
                    localTeamLoader.saveIgnoringResult(teams, with: league.id)
                }
                
                return teams
            }
        }
        return TeamViewModel(teamLoader: teamLoader)
    }
    
    func composePlayerViewModel(for team: Team) -> PlayerViewModel {
        let playerLoader: () async throws -> [Player] = { [httpClient, localPlayerLoader] in
            
            do {
                return try localPlayerLoader.load(with: team.id)
            } catch {
                let url = PlayerEndpoint.get(sportId: 1,
                                             locale: "es_MX",
                                             teamId: team.id).url(baseURL: self.baseURL)
                let (data, response) = try await httpClient.get(from: url)
                
                let players = try PlayerMapper.map(data, from: response)
                
                Task {
                    localPlayerLoader.saveIgnoringResult(players, with: team.id)
                }
                
                return players
            }
        }
        return PlayerViewModel(playerLoader: playerLoader)
    }
    
    func composeImageView(with url: URL, on table: Table) -> ImageView {
        let imageLoader: () async throws -> Data = { [httpClient, localImageLoader] in
            
            do {
                return try localImageLoader.loadImageData(from: url, on: table)
            } catch {
                let (data, response) = try await httpClient.get(from: url)
                
                let imageData = try ImageMapper.map(data, from: response)
                
                Task {
                    localImageLoader.saveIgnoringResult(imageData, for: url, on: table)
                }
                
                return imageData
            }
        }
        let imageViewModel = ImageViewModel(imageLoader: imageLoader,
                                            imageTransformer: UIImage.init)
        return ImageView(imageViewModel: imageViewModel)
    }
    
    func validateCache() {
        Task {
            try? localLeagueLoader.validateCache()
        }
    }
}

private extension LeagueCache {
    func saveIgnoringResult(_ leagues: [League]) {
        try? save(leagues)
    }
}

private extension TeamCache {
    func saveIgnoringResult(_ teams: [Team], with id: String) {
        try? save(teams, with: id)
    }
}

private extension PlayerCache {
    func saveIgnoringResult(_ players: [Player], with id: String) {
        try? save(players, with: id)
    }
}

private extension ImageCache {
    func saveIgnoringResult(_ data: Data, for url: URL, on table: Table) {
        try? save(data, for: url, on: table)
    }
}
