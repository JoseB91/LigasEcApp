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
    @StateObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        List {
            if playerViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(playerViewModel.squad) { player in
                    HStack {
                        AsyncImage(url: player.photoURL) { phase in
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
                        Text(player.name)
                            .font(.title2)
                    }
                }
            }
        }
        .listRowSeparator(.hidden)
        .listStyle(.insetGrouped)
        .listRowSpacing(12)
        .navigationTitle(playerViewModel.title)
        .toolbarTitleDisplayMode(.inline)
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
    let playerViewModel = PlayerViewModel(
        playerLoader: MockPlayerViewModel.mockPlayerLoader
    )
    
    PlayerView(playerViewModel: playerViewModel)
}
