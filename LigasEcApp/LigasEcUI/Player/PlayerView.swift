//
//  PlayerView.swift
//  LigasEcApp
//
//  Created by José Briones on 26/2/25.
//

import SwiftUI
import LigasEcAPI
import SharedAPI

//TODO: Change UI and add number
struct PlayerView: View {
    @ObservedObject var playerViewModel: PlayerViewModel
    let imageView: (URL, Table) -> ImageView

    var body: some View {
        List {
            if playerViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
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
                                            .overlay(Circle().stroke(Color.white, lineWidth: 1)) // Opcional, para agregar un borde blanco
                                            .shadow(radius: 10) // Opcional, agrega una sombra
                                    } else {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 96, height: 48)
                                    }
                                    Text(player.name)
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .listRowSeparator(.hidden)
        .listStyle(.insetGrouped)
        .listRowSpacing(12)
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
