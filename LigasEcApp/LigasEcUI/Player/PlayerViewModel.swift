//
//  PlayerViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 26/2/25.
//

import Foundation

@Observable
final class PlayerViewModel {

    var squad = [Player]()
    var isLoading = false
    var errorMessage: ErrorModel? = nil

    private let repository: PlayerRepository
    
    var coach: String {
        String(localized: "COACH",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }
    
    var goalkeeper: String {
        String(localized: "GOALKEEPER",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }

    var defender: String {
        String(localized: "DEFENDER",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }

    var midfielder: String {
        String(localized: "MIDFIELDER",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }

    var forward: String {
        String(localized: "FORWARD",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }

    
    init(repository: PlayerRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadSquad() async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            squad = try await repository.loadPlayers()
        } catch {
            errorMessage = ErrorModel(message: error.localizedDescription)
        }
    }
    
    func getLocalizedPosition(for position: String) -> String {
        switch position {
        case "Portero":
            return goalkeeper
        case "Defensa":
            return defender
        case "Centrocampista":
            return midfielder
        case "Delantero":
            return forward
        case "Entrenador":
            return coach
        default:
            return ""
        }
    }
    
    func getCountryId(for country: String) -> Int {
        switch country {
        case "Argentina":
            return 22
        case "Brasil":
            return 39
        case "Colombia":
            return 53
        case "Ecuador":
            return 68
        case "Nigeria":
            return 143
        case "Paraguay":
            return 151
        case "Uruguay":
            return 201
        case "Venezuela":
            return 205
        default:
            return 0
        }
    }
}

struct MockPlayerViewModel {
    static func mockPlayers() -> [Player] {
        return [Player(id: "S0nWKdXm",
                       name: "Contreras José",
                       number: 1,
                       position: "Portero",
                       photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
                       dataSource: .flashLive),
                Player(id: "S0nWKdXn",
                               name: "Contreras José",
                               number: 1,
                               position: "Portero",
                               photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
                               dataSource: .flashLive)]
    }
    
    static func mockPlayer() -> Player {
        return Player(id: "S0nWKdXm",
                       name: "Contreras José",
                       number: 1,
                       position: "Portero",
                       photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
                       dataSource: .flashLive)
    }
}

struct MockPlayerRepository: PlayerRepository {
    func loadPlayers() async throws -> [Player] {
        MockPlayerViewModel.mockPlayers()
    }
}
