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
        
    var body: some View {
        List {
            if leagueViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(leagueViewModel.leagues) { league in
                    NavigationLink(destination: leagueViewModel.selection(league)) {
                        HStack {
                            AsyncImage(url: league.logoURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
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
            }
        }
        .listRowSeparator(.hidden)
        .listStyle(.insetGrouped)
        .listRowSpacing(12)
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
    

#Preview {
    let teamViewModel = TeamViewModel(teamLoader: MockTeamViewModel.mockTeamLoader)
    let leagueViewModel = LeagueViewModel(
        leagueLoader: MockLeagueViewModel.mockLeagueLoader, selection: { _ in TeamView(teamViewModel: teamViewModel)}
    )
    LeagueView(
        leagueViewModel: leagueViewModel)
}



