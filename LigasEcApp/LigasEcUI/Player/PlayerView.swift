//
//  PlayerView.swift
//  LigasEcApp
//
//  Created by José Briones on 26/2/25.
//

import SwiftUI

struct PlayerView: View {
    @State var playerViewModel: PlayerViewModel
    let imageViewLoader: (URL, Table) -> ImageView
    let title: String
    
    var body: some View {
        List {
            if playerViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            } else {
                
                let groupedPlayers = Dictionary(grouping: playerViewModel.squad, by: { $0.position })
                
                let positionOrder = [Constants.portero, Constants.defensa, Constants.centrocampista, Constants.delantero, Constants.entrenador]
                
                ForEach(positionOrder, id: \.self) { position in
                    if let positionGroup = groupedPlayers[position], !positionGroup.isEmpty {
                        Section(header: Text(position != Constants.entrenador ?
                                             position.getPlayerLocalizedPosition() :
                                                Constants.coach)) {
                            ForEach(positionGroup) { player in
                                HStack {
                                    if let url = player.photoURL {
                                        imageViewLoader(url, .player)
                                            .frame(width: 72, height: 36)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))
                                    } else {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 72, height: 36)
                                    }
                                    Text(player.name)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .frame(width: 150, alignment: .leading)
                                    if let flagId = player.flagId {
                                        Image("country_flag_\(flagId)")
                                            .resizable()
                                            .frame(width: 24, height: 16)
                                    } else if let nationality = player.nationality {
                                        let flagId = nationality.getPlayerCountryId()
                                        Image("country_flag_\(flagId)")
                                            .resizable()
                                            .frame(width: 24, height: 16)
                                            .accessibilityLabel(nationality)
                                    }
                                    if position != Constants.entrenador {
                                        Spacer()
                                        ZStack{
                                            Image("tshirt")
                                                .renderingMode(.template)
                                                .foregroundStyle(Color.primary)
                                            if let number = player.number {
                                                Text("\(String(number))")
                                                    .font(.caption)
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                    }
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .listRowSpacing(4)
        .navigationTitle(title)
        .toolbarTitleDisplayMode(.large)
        .refreshable {
            await playerViewModel.loadSquad()
        }
        .task {
            await playerViewModel.loadSquad()
        }
        .withErrorAlert(errorModel: $playerViewModel.errorModel)
    }
}


#Preview {
    let playerViewModel = PlayerViewModel(repository: MockPlayerRepository())
    
    PlayerView(playerViewModel: playerViewModel,
               imageViewLoader: MockImageComposer().composeImageView,
               title: "Barcelona SC")
}


