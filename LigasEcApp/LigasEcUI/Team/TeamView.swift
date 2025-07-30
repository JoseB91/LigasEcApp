//
//  TeamView.swift
//  LigasEcApp
//
//  Created by José Briones on 25/2/25.
//

import SwiftUI

struct TeamView: View {
    @State var teamViewModel: TeamViewModel
    @Binding var navigationPath: NavigationPath
    let imageViewLoader: (URL, Table) -> ImageView
    let title: String
    
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
                            imageViewLoader(team.logoURL, Table.Team)
                                .frame(width: 96, height: 48)
                            Text(team.name)
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
            }
        }
        .listRowSpacing(12)
        .listStyle(.insetGrouped)
        .navigationTitle(title)
        .toolbarTitleDisplayMode(.large)
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
    NavigationStack {
        let teamViewModel = TeamViewModel(repository: MockTeamRepository())
        
        TeamView(teamViewModel: teamViewModel,
                 navigationPath: .constant(NavigationPath()),
                 imageViewLoader: MockImageComposer().composeImageView,
                 title: "LigaPro Serie A")
    }
}
