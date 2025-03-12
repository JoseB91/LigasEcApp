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
    private let localTeamLoader: LocalTeamLoader
    
    //let logger = Logger(subsystem: "com.joseB91.LatinCoaches", category: "main")

    init(baseURL: URL, httpClient: URLSessionHTTPClient, localTeamLoader: LocalTeamLoader) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localTeamLoader = localTeamLoader
    }
    
    static func makeComposer() -> Composer {
        let baseURL = URL(string: "https://flashlive-sports.p.rapidapi.com/v1/")!
        let httpClient = makeHTTPClient()
        let store = makeStore()
        let localTeamLoader = LocalTeamLoader(store: store, currentDate: Date.init)
        
        return Composer(baseURL: baseURL, httpClient: httpClient, localTeamLoader: localTeamLoader)
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
    
    private static func makeStore() -> TeamStore {
        do {
            return try CoreDataLigasEcStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("ligas-ec-store.sqlite"),
                contextQueue: .background)
        } catch {
            // Add logger
            return InMemoryStore()
        }
    }
    
    func composeTeamViewModel(for league: League) -> TeamViewModel {
        let teamLoader: () async throws -> [Team] = { [localTeamLoader] in
            
            do {
                return try localTeamLoader.load()
            } catch {
                let url = TeamEndpoint.get(seasonId: league.id,
                                           standingType: "overall", // TODO: Manage constants
                                           locale: "es_MX", // TODO: Get locale
                                           tournamentStageId: league.stageId).url(baseURL: self.baseURL)
                let (data, response) = try await self.httpClient.get(from: url)
                
                let teams = try TeamMapper.map(data, from: response)
                
                Task {
                    localTeamLoader.saveIgnoringResult(teams)
                }
                
                return teams
                
            }
        }
        return TeamViewModel(teamLoader: teamLoader)
    }
    
    func composePlayerViewModel(for team: Team) -> PlayerViewModel {
        let playerLoader: () async throws -> [Player] = { [httpClient] in
            let url = PlayerEndpoint.get(sportId: 1,
                                       locale: "es_MX",
                                       teamId: team.id).url(baseURL: self.baseURL)
            let (data, response) = try await httpClient.get(from: url)
            
            return try PlayerMapper.map(data, from: response)
        }
        return PlayerViewModel(playerLoader: playerLoader)
    }
    
    
    func composeImageView(model: Team) -> ImageView {
        let imageLoader: () async throws -> Data = { [httpClient] in
            guard let url = model.logoURL else {
                //TODO: Log error
                return Data() // Handle this
            }
            let (data, response) = try await httpClient.get(from: url)
 
            return try ImageMapper.map(data, from: response)
        }
 
        let imageViewModel = ImageViewModel(imageLoader: imageLoader,
                                            imageTransformer: UIImage.init)
        return ImageView(imageViewModel: imageViewModel)
    }
}

private extension TeamCache {
    func saveIgnoringResult(_ teams: [Team]) {
        try? save(teams)
    }
}
