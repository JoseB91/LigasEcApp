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
    
    let baseURL = URL(string: "https://v3.football.api-sports.io")!
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
                LeagueView(leagueViewModel: composeLeagueViewModel())
            }
        }
    }
    
    private func composeLeagueViewModel() -> LeagueViewModel {
        let leagueLoader: () async throws -> [League] = {
            let url = LeagueEndpoint.get(country: "Ecuador", season: "2023" ).url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            
            return try LeagueMapper.map(data, from: response)
        }
        return LeagueViewModel(leagueLoader: leagueLoader)
    }
}
    
