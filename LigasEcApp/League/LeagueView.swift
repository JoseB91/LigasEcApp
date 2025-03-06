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
    let leagueViewModel: LeagueViewModel
        
    var body: some View {
        List(leagueViewModel.leagues) { league in
                NavigationLink(destination: leagueViewModel.selection(league)) {
                    HStack {
                        AsyncImage(url: league.logoURL) { phase in
                            switch phase {
                            case .empty:
                                Image(systemName: "soccerball")
                            case .success(let image):
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 96, height: 48)
                            case .failure(_):
                                Image(systemName: "soccerball")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        Text(league.name)
                            .font(.title2)
                    }
                }
        }
        .listRowSeparator(.hidden)
        .listRowSpacing(12)
        .listStyle(.insetGrouped)
        .navigationTitle(leagueViewModel.title)
        .toolbarTitleDisplayMode(.inline)
    }
}
    

#Preview {
    let playerViewModel = PlayerViewModel(playerLoader: MockPlayerViewModel.mockPlayerLoader)
    
    let teamViewModel = TeamViewModel(
        teamLoader: MockTeamViewModel.mockTeamLoader,
        selection: { _ in PlayerView(playerViewModel: playerViewModel)}
    )
    
    let leagueViewModel = LeagueViewModel(
        selection: { _ in TeamView(teamViewModel: teamViewModel)}
    )
    
    LeagueView(leagueViewModel: leagueViewModel)
}
