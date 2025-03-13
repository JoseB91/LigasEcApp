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
    @ObservedObject var teamViewModel: TeamViewModel
    @Binding var navigationPath: NavigationPath
    let imageView: (URL, Table) -> ImageView
    
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
                            if let url = team.logoURL {
                                imageView(url, Table.Team)
                                    .frame(width: 96, height: 48)
                            }
                            Text(team.name)
                                .font(.title2)
                        }
                    }.tint(.black)
                }
            }
        }
        .listRowSeparator(.hidden)
        .listRowSpacing(12)
        .listStyle(.insetGrouped)
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

    TeamView(teamViewModel: teamViewModel,
             navigationPath: .constant(NavigationPath()),
             imageView: MockImageView.mockImageView)
}



