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

@main
struct LigasEcApp: App {
    
    let baseURL = URL(string: "https://v3.football.api-sports.io")!
    let httpClient = URLSessionHTTPClient(
        session: URLSession(configuration: .ephemeral),
        apiKey: "c3f7e1d18170e13fe81a3a865b4cf1b3")

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
    
//struct LigasEcApp: App {
//    
//    let baseURL = URL(string: "https://v3.football.api-sports.io")!
//    let httpClient: URLSessionHTTPClient
//    
//    init() {
//        // Try to get API key from Keychain
//        var apiKey = ""
//        
//        do {
//            // Try to retrieve API key from Keychain
//            apiKey = try KeychainManager.retrieveAPIKey()
//        } catch KeychainError.itemNotFound {
//            // Key not found, check if we have a default key to save
//            if let bundleAPIKey = Bundle.main.infoDictionary?["DEFAULT_API_KEY"] as? String,
//               !bundleAPIKey.isEmpty {
//                apiKey = bundleAPIKey
//                
//                // Save it to keychain for future use
//                try? KeychainManager.saveAPIKey(apiKey)
//                print("Default API key saved to Keychain")
//            } else {
//                print("No API key found in Keychain or Bundle")
//                // In a real app, you might want to show an error or prompt for the key
//            }
//        } catch {
//            print("Error retrieving API key: \(error.localizedDescription)")
//        }
//        
//        self.httpClient = URLSessionHTTPClient(
//            session: URLSession(configuration: .ephemeral),
//            apiKey: apiKey)
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            NavigationStack {
//                ContentView(leagueViewModel: composeLeagueViewModel(),
//                            imageView: composeImageViewModel)
//            }
//        }
//    }
//    
//    private func composeLeagueViewModel() -> LeagueViewModel {
//        let leagueLoader: () async throws -> [League] = {
//            let url = LeagueEndpoint.get(country: "Ecuador", season: "2023" ).url(baseURL: baseURL)
//            let (data, response) = try await httpClient.get(from: url)
//            
//            return try LeagueMapper.map(data, from: response)
//        }
//        return LeagueViewModel(leagueLoader: leagueLoader)
//    }
//    
//    private func composeImageViewModel(model: League) -> ImageView {
//        let imageLoader: () async throws -> Data = {
//            let (data, response) = try await httpClient.get(from: model.logoURL)
//            
//            return try ImageMapper.map(data, from: response)
//        }
//        let imageViewModel = ImageViewModel(imageURL: model.logoURL, imageLoader: imageLoader, imageTransformer: UIImage.init)
//        return ImageView(imageViewModel: imageViewModel)
//    }
//}
