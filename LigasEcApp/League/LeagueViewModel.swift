//
//  LeagueViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import Combine
import LigasEcAPI
import SharedAPI

final class LeagueViewModel: ObservableObject {

    @Published var leagues = [League]()
    @Published var isLoading = false
    @Published var errorMessage: ErrorModel? = nil

    let selection: (League) -> TeamView
    private let leagueLoader: () async throws -> [League]
    
    var title: String {
        String(localized: "LEAGUE_VIEW_TITLE",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }
    
    init(leagueLoader: @escaping () async throws -> [League], selection: @escaping (League) -> TeamView) {
        self.leagueLoader = leagueLoader
        self.selection = selection
    }
    
    @MainActor
    func loadLeagues() async {
        isLoading = true
        do {
            leagues = try await leagueLoader()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load leagues: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

struct ErrorModel: Identifiable {
    let id = UUID()
    let message: String
}

final class MockLeagueViewModel {
    static func mockLeagueLoader() async throws -> [League] {
        return [
            League(id: 1, name: "Liga Pro", logoURL: URL(string: "https://media.api-sports.io/football/leagues/243.png")!),
            League(id: 1, name: "Liga Pro", logoURL: URL(string: "https://media.api-sports.io/football/leagues/243.png")!),
        ]
    }
}
