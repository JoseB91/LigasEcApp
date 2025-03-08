//
//  TeamView.swift
//  LigasEcApp
//
//  Created by José Briones on 25/2/25.
//

import SwiftUI
import LigasEcAPI
import SharedAPI

struct TeamView: View {
    @StateObject var teamViewModel: TeamViewModel
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        List {
            if teamViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(teamViewModel.teams) { team in
                    Button {
                        navigationPath.append(team)
                    } label: {
                        HStack {
                            AsyncImage(url: team.logoURL) { phase in
                                switch phase {
                                case .empty:
                                    Image(systemName: "soccerball") // TODO: Change
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 96, height: 48)
                                case .failure(_):
                                    Image(systemName: "soccerball") // TODO: Change
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            Text(team.name)
                                .font(.title2)
                        }
                    }.tint(.black)
                }
            }
        }
        .listRowSeparator(.hidden)
        .listStyle(.insetGrouped)
        .listRowSpacing(12)
        .navigationTitle(teamViewModel.title)
        .toolbarTitleDisplayMode(.inline)
        .refreshable {
            await teamViewModel.loadTeams()
        }
        .task {
            await teamViewModel.loadTeams()
        }
        .alert(item: $teamViewModel.errorMessage) { error in
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

    TeamView(teamViewModel: teamViewModel, navigationPath: .constant(NavigationPath()))
}



