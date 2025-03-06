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
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LeagueView(leagueViewModel: LeagueViewModel(selection: composeTeamView))
            }
        }
    }
        
    func composeTeamView(for league: League) -> TeamView {
        let teamLoader: () async throws -> [Team] = {
            let url = TeamEndpoint.get(seasonId: league.id,
                                       standingType: "overall", // TODO: Manage constants
                                       locale: "es_MX", // TODO: Get locale
                                       tournamentStageId: league.stageId).url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            
            return try TeamMapper.map(data, from: response)
        }
        let teamViewModel = TeamViewModel(teamLoader: teamLoader, selection: composePlayerView)
        return TeamView(teamViewModel: teamViewModel)
    }
    
    func composePlayerView(for team: Team) -> PlayerView {
        let playerLoader: () async throws -> [Player] = {
            let url = PlayerEndpoint.get(sportId: 1,
                                         locale: "es_MX",
                                         teamId: team.id).url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            
            return try PlayerMapper.map(data, from: response)
        }
        let playerViewModel = PlayerViewModel(playerLoader: playerLoader)
        return PlayerView(playerViewModel: playerViewModel)
    }
}

final class UIComposer {}
