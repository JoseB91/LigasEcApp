//
//  PlayerViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 26/2/25.
//

import LigasEcAPI
import SharedAPI

final class PlayerViewModel: ObservableObject {

    @Published var squad = [Player]()
    @Published var isLoading = false
    @Published var errorMessage: ErrorModel? = nil

    private let playerLoader: () async throws -> [Player]
    
    var title: String {
        String(localized: "PLAYER_VIEW_TITLE",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }
    
    init(playerLoader: @escaping () async throws -> [Player]) {
        self.playerLoader = playerLoader
    }
    
    @MainActor
    func loadSquad() async {
        isLoading = true
        do {
            squad = try await playerLoader()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load squad: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

final class MockPlayerViewModel {
    static func mockPlayerLoader() async throws -> [Player] {
        return [
            Player(id: "1",
                   name: "Alexander Domínguez Carabalí",
                   number: 22,
                   position: "Goalkeeper",
                   photoURL: URL(string: "https://media.api-sports.io/football/players/2568.png")!),
            Player(id: "2",
                   name: "G. Valle",
                   number: 1,
                   position: "Goalkeeper",
                   photoURL: URL(string: "https://media.api-sports.io/football/players/16642.png")!)

        ]
    }
}

