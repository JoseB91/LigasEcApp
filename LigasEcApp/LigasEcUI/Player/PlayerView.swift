//
//  PlayerView.swift
//  LigasEcApp
//
//  Created by José Briones on 26/2/25.
//

import SwiftUI
import LigasEcAPI
import SharedAPI

struct PlayerView: View {
    @ObservedObject var playerViewModel: PlayerViewModel
    let imageView: (URL, Table) -> ImageView

    var body: some View {
        List {
            if playerViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            } else {

                let groupedPlayers = Dictionary(grouping: playerViewModel.squad, by: { $0.position })

                let positionOrder = ["Portero", "Defensa", "Centrocampista", "Delantero", "Entrenador"]
                
                ForEach(positionOrder, id: \.self) { position in
                    if let positionGroup = groupedPlayers[position], !positionGroup.isEmpty {
                        Section(header: Text(position != "Entrenador" ?
                                             playerViewModel.getLocalizedPosition(for: position) + "s" :
                                                playerViewModel.coach)) {
                            ForEach(positionGroup) { player in
                                HStack {
                                    if let url = player.photoURL {
                                        imageView(url, Table.Player)
                                            .frame(width: 96, height: 48)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))
                                    } else {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 96, height: 48)
                                    }
                                    Text(player.name)
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                        .frame(width: 150, alignment: .leading)
//                                    if let flagId = player.flagId {
//                                        Image("country_flag_\(flagId)")
//                                            .resizable()
//                                            .scaledtoFit()
//                                            .frame(width: 24, height: 16)
//                                    }
                                    if position != "Entrenador" {
                                        Spacer()
                                        ZStack{
                                            Image("tshirt")
                                                .renderingMode(.template)
                                                .foregroundStyle(Color.primary)
                                            Text("\(String(player.number))")
                                                .font(.caption)
                                                .foregroundColor(.primary)
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
        .listRowSpacing(0)
        .navigationTitle(playerViewModel.title)
        .toolbarTitleDisplayMode(.large)
        .refreshable {
            await playerViewModel.loadSquad()
        }
        .task {
            await playerViewModel.loadSquad()
        }
        .alert(item: $playerViewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
    

#Preview {
    let playerViewModel = PlayerViewModel(playerLoader: MockPlayerViewModel.mockPlayerLoader)
    
    PlayerView(playerViewModel: playerViewModel, imageView: MockImageView.mockImageView)
}
