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
        return [Player(id: "S0nWKdXm",
                       name: "Contreras José",
                       number: 1,
                       position: "GOALKEEPER",
                       photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!)]
    }
}

