//
//  PlayerViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 26/2/25.
//

import Foundation
import SwiftUI

final class PlayerViewModel: ObservableObject {
    private static let preferredPositionOrder: [Player.Position] = [
        .goalkeeper,
        .defender,
        .midfielder,
        .forward,
        .coach
    ]

    @Published var squad = [Player]()
    @Published var isLoading = false
    @Published var errorModel: ErrorModel? = nil

    private let repository: PlayerRepository
    private var hasLoaded = false
        
    init(repository: PlayerRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        await loadSquad()
    }
    
    @MainActor
    func loadSquad() async {
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            squad = try await repository.loadPlayers()
        } catch {
            errorModel = ErrorModel(message: error.localizedDescription)
        }
    }

    func orderedPositions(from groupedPlayers: [Player.Position: [Player]]) -> [Player.Position] {
        let knownPositions = Self.preferredPositionOrder.filter { groupedPlayers[$0]?.isEmpty == false }
        let unknownPositions = groupedPlayers.keys.filter {
            if case .unknown = $0 {
                return groupedPlayers[$0]?.isEmpty == false
            }
            return false
        }.sorted { $0.storageValue < $1.storageValue }

        return knownPositions + unknownPositions
    }

    func title(for position: Player.Position) -> Text? {
        switch position {
        case .goalkeeper:
            return Text(Constants.goalkeeper)
        case .defender:
            return Text(Constants.defender)
        case .midfielder:
            return Text(Constants.midfielder)
        case .forward:
            return Text(Constants.forward)
        case .coach:
            return Text(Constants.coach)
        case let .unknown(value):
            guard !value.isEmpty else { return nil }
            return Text(verbatim: value)
        }
    }
}
