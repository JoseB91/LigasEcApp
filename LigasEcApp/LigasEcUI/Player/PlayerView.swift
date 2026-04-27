//
//  PlayerView.swift
//  LigasEcApp
//
//  Created by José Briones on 26/2/25.
//

import SwiftUI

struct PlayerView: View {
    @StateObject private var playerViewModel: PlayerViewModel
    let imageViewLoader: (URL, Table) -> ImageView
    let title: String

    init(playerViewModel: PlayerViewModel,
         imageViewLoader: @escaping (URL, Table) -> ImageView,
         title: String) {
        _playerViewModel = StateObject(wrappedValue: playerViewModel)
        self.imageViewLoader = imageViewLoader
        self.title = title
    }
    
    var body: some View {
        List {
            if playerViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                    .accessibilityLabel(Constants.loadingPlayers)
            } else {
                let groupedPlayers = Dictionary(grouping: playerViewModel.squad, by: \.position)
                let orderedPositions = playerViewModel.orderedPositions(from: groupedPlayers)

                ForEach(orderedPositions, id: \.self) { position in
                    if let positionGroup = groupedPlayers[position],
                       !positionGroup.isEmpty,
                       let title = playerViewModel.title(for: position) {
                        Section {
                            ForEach(positionGroup) { player in
                                HStack(spacing: 8) {
                                    Spacer(minLength: 4)
                                    if position != .coach {
                                        ZStack {
                                            ShirtIconView()
                                                .frame(width: 36, height: 36)
                                            if let number = player.number {
                                                Text("\(String(number))")
                                                    .font(.caption)
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                        .accessibilityLabel(player.number != nil ? "Player number \(player.number!)" : "")
                                        .padding(.trailing, 10)
                                    }
                                    if let url = player.photoURL {
                                        imageViewLoader(url, .player)
                                            .frame(width: 56, height: 56)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))
                                            .accessibilityLabel(player.name)
                                    } else {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 56, height: 56)
                                            .accessibilityLabel(Constants.noPhotoAvailable)
                                    }
                                    Text(player.name)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.85)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer(minLength: 4)
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
                                    Spacer()
                                        .frame(width: 16)
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                            }
                        } header: {
                            title
                                .font(.subheadline.weight(.semibold))
                                .textCase(nil)
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
            await playerViewModel.loadIfNeeded()
        }
        .withErrorAlert(errorModel: $playerViewModel.errorModel)
    }
}

private struct ShirtIconView: View {
    var body: some View {
        Image("tshirt")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.primary)
    }
}


#Preview {
    let playerViewModel = PlayerViewModel(repository: MockPlayerRepository())
    
    PlayerView(playerViewModel: playerViewModel,
               imageViewLoader: MockImageComposer().composeImageView,
               title: "Barcelona SC")
}
