//
//  PlayerDetailView.swift
//  LigasEcApp
//
//  Created by José Briones on 8/7/26.
//

import SwiftUI

struct PlayerDetailView: View {
    @Bindable var playerDetailViewModel: PlayerDetailViewModel
    let imageViewLoader: (URL, Table) -> ImageView

    var body: some View {
        if playerDetailViewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden)
                .accessibilityLabel(Constants.loadingPlayerDetail)
        } else {
            VStack(spacing: 24) {
                if let url = playerDetailViewModel.playerDetail.imagePath {
                    imageViewLoader(url, .player)
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))
                        .accessibilityLabel(playerDetailViewModel.playerDetail.name)
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .accessibilityLabel(Constants.noPhotoAvailable)
                }
                
                Text(playerDetailViewModel.playerDetail.name)
                    .font(.title2.weight(.semibold))
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 32) {
                    ZStack {
                        Image("tshirt")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.primary)
                            .frame(width: 44, height: 44)
                        Text("\(String(1))")
                            .font(.callout)
                            .foregroundColor(.primary)
                    }
                    .accessibilityLabel("Player number 1")
                    
                    if let flagId = playerDetailViewModel.flagId {
                        HStack(spacing: 8) {
                            Image("country_flag_\(flagId)")
                                .resizable()
                                .frame(width: 30, height: 20)
                            if let nationality = playerDetailViewModel.playerDetail.countryName {
                                Text(nationality)
                                    .font(.callout)
                                    .foregroundColor(.primary)
                            }
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 32)
            .padding(.horizontal, 20)
            .navigationTitle(playerDetailViewModel.playerDetail.name)
            .toolbarTitleDisplayMode(.inline)
            .task {
                await playerDetailViewModel.loadPlayerDetail()
            }
            .withErrorAlert(errorModel: $playerDetailViewModel.errorModel)
        }
    }
}

//#Preview {
//    NavigationStack {
//        let playerDetailViewModel = PlayerDetailViewModel(player: MockPlayerViewModel.mockPlayers()[0])
//
//        PlayerDetailView(playerDetailViewModel: playerDetailViewModel,
//                         imageViewLoader: MockImageComposer().composeImageView)
//    }
//}
