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

    
    init(playerLoader: @escaping () async throws -> [Player]) {
        self.playerLoader = playerLoader
    }
    
    @MainActor
    func loadSquad() async {
        isLoading = true
        do {
            squad = try await playerLoader()
        } catch {
            if error is MapperError {
                print("No players for this team")
            } else {
                errorMessage = ErrorModel(message: "Failed to load squad: \(error.localizedDescription)")
            }
        }
        isLoading = false
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
        default:
            return 0
        }
    }
}

final class MockPlayerViewModel {

    static func mockPlayerLoader() async throws -> [Player] {
        return [Player(id: "S0nWKdXm",
                       name: "Contreras José",
                       number: 1,
                       position: "Portero",
                       photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
                       dataSource: .FlashLive)]
    }
}

