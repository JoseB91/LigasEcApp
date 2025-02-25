//
//  LeagueView.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import SwiftUI
import LigasEcAPI
import SharedAPI

struct LeagueView: View {
    @StateObject var leagueViewModel: LeagueViewModel
    let imageView: (League) -> ImageView
    
    var body: some View {
        List {
            if leagueViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(leagueViewModel.leagues) { league in
                    HStack {
                        imageView(league)
                            .frame(width: 96, height: 48)
                            .clipped()
                        Text(league.name)
                            .font(.title2)
                    }
                }
            }
        }
        .listRowSeparator(.hidden)
        .listStyle(.insetGrouped)
        .listRowSpacing(12) // Adds space between rows
        .navigationTitle(leagueViewModel.title)
        .toolbarTitleDisplayMode(.inline)
        .refreshable {
            await leagueViewModel.loadLeagues()
        }
        .task {
            await leagueViewModel.loadLeagues()
        }
        .alert(item: $leagueViewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// TODO: Manage Preview
//#Preview {
//    let baseURL = URL(string: "https://v3.football.api-sports.io")!
//    let httpClient = URLSessionHTTPClient(
//        session: URLSession(configuration: .ephemeral),
//        apiKey: "c3f7e1d18170e13fe81a3a865b4cf1b3")
//    let leagueLoader: () async throws -> [League] = {
//        let url = LeagueEndpoint.get(country: "Ecuador", season: "2023" ).url(baseURL: baseURL)
//        let (data, response) = try await httpClient.get(from: url)
//
//        return try LeagueMapper.map(data, from: response)
//    }
//    let leagueViewModel = LeagueViewModel(leagueLoader: leagueLoader)
//
//    let imageURL = URL(string: "https://media.api-sports.io/football/leagues/243.png")!
//    let imageLoader: () async throws -> Data = {
//        let (data, response) = try await httpClient.get(from: imageURL)
//        
//        return try ImageMapper.map(data, from: response)
//    }
//    
//    let imageViewModel = ImageViewModel(imageURL: imageURL, imageLoader: imageLoader, imageTransformer: UIImage.init)
//    
//    func composeImageView(model: League) -> ImageView {
//        let imageLoader: () async throws -> Data = {
//            let (data, response) = try await httpClient.get(from: model.logoURL)
//            
//            return try ImageMapper.map(data, from: response)
//        }
//        let imageViewModel = ImageViewModel(imageURL: model.logoURL, imageLoader: imageLoader, imageTransformer: UIImage.init)
//        ImageView(imageViewModel: imageViewModel)
//    }
//    
//    LeagueView(leagueViewModel: leagueViewModel,
//               imageView: composeImageView)
//}
