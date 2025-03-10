//
//  LigasEcApp.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import SwiftUI
import Combine
import LigasEcAPI
import SharedAPI
import Security
import CoreData
import os

@main
struct LigasEcApp: App {
    
    let baseURL = URL(string: "https://flashlive-sports.p.rapidapi.com/v1/")!
    let httpClient: URLSessionHTTPClient
    
    init() {
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
        
        self.httpClient = URLSessionHTTPClient(
            session: URLSession(configuration: .ephemeral),
            apiKey: apiKey)
    }
    
    private lazy var logger = Logger(subsystem: "com.joseB91.LatinCoaches", category: "main")

    private lazy var store: TeamStore = {
        do {
            return try CoreDataLigasEcStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("ligas-ec-store.sqlite"))
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            logger.fault("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return InMemoryStore()
        }
    }()
    
    @State private var navigationPath = NavigationPath()
        
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                LeagueView(leagueViewModel: LeagueViewModel(), navigationPath: $navigationPath)
                    .navigationDestination(for: League.self) { league in
                        TeamView(teamViewModel: composeTeamViewModel(for: league), navigationPath: $navigationPath)
                    }
                    .navigationDestination(for: Team.self) { team in
                        PlayerView(playerViewModel: composePlayerViewModel(for: team))
                    }
            }
        }
    }
        
    func composeTeamViewModel(for league: League) -> TeamViewModel {
        let teamLoader: () async throws -> [Team] = {
            let url = TeamEndpoint.get(seasonId: league.id,
                                       standingType: "overall", // TODO: Manage constants
                                       locale: "es_MX", // TODO: Get locale
                                       tournamentStageId: league.stageId).url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            
            return try TeamMapper.map(data, from: response)
        }
        return TeamViewModel(teamLoader: teamLoader)
    }
    
    func composePlayerViewModel(for team: Team) -> PlayerViewModel {
        let playerLoader: () async throws -> [Player] = {
            let url = PlayerEndpoint.get(sportId: 1,
                                         locale: "es_MX",
                                         teamId: team.id).url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            
            return try PlayerMapper.map(data, from: response)
        }
        return PlayerViewModel(playerLoader: playerLoader)
    }
}

//TODO: Add Acceptance and UIIntegration tests
