//
//  PlayerDetailView.swift
//  LigasEcApp
//
//  Created by José Briones on 8/7/26.
//

import SwiftUI

struct PlayerDetailView: View {
    let playerDetailViewModel: PlayerDetailViewModel
    let imageViewLoader: (URL, Table) -> ImageView

    var body: some View {
        VStack(spacing: 24) {
            if let url = playerDetailViewModel.photoURL {
                imageViewLoader(url, .player)
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))
                    .accessibilityLabel(playerDetailViewModel.name)
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .accessibilityLabel(Constants.noPhotoAvailable)
            }

            Text(playerDetailViewModel.name)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)

            HStack(spacing: 32) {
                if let number = playerDetailViewModel.number {
                    ZStack {
                        Image("tshirt")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.primary)
                            .frame(width: 44, height: 44)
                        Text("\(String(number))")
                            .font(.callout)
                            .foregroundColor(.primary)
                    }
                    .accessibilityLabel("Player number \(number)")
                }

                if let flagId = playerDetailViewModel.flagId {
                    HStack(spacing: 8) {
                        Image("country_flag_\(flagId)")
                            .resizable()
                            .frame(width: 30, height: 20)
                        if let nationality = playerDetailViewModel.nationality {
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
        .navigationTitle(playerDetailViewModel.name)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        let playerDetailViewModel = PlayerDetailViewModel(player: MockPlayerViewModel.mockPlayers()[0])

        PlayerDetailView(playerDetailViewModel: playerDetailViewModel,
                         imageViewLoader: MockImageComposer().composeImageView)
    }
}
