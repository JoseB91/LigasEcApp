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
        //TODO: Change UI
        ZStack {
            if teamViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    ForEach(teamViewModel.teams) { team in
                        Button {
                            navigationPath.append(team)
                        } label: {
                            HStack {
                                imageViewLoader(team.logoURL, .team)
                                    .frame(width: 96, height: 48)
                                Text(team.name)
                                    .font(.title2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cardStyle()
                        }
                        .padding(.horizontal, 20)
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .navigationTitle(title)
        .toolbarTitleDisplayMode(.large)
        .refreshable {
            await teamViewModel.loadTeams()
        }
        .task {
            await teamViewModel.loadTeams()
        }
        .withErrorAlert(errorModel: $teamViewModel.errorModel)
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
