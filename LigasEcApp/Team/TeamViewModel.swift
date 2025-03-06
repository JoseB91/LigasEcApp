//
//  TeamViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 25/2/25.
//

import LigasEcAPI
import SharedAPI

final class TeamViewModel: ObservableObject {

    @Published var teams = [Team]()
    @Published var isLoading = false
    @Published var errorMessage: ErrorModel? = nil

    let selection: (Team) -> PlayerView
    private let teamLoader: () async throws -> [Team]
    
    var title: String {
        String(localized: "TEAM_VIEW_TITLE",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }
    
    init(teamLoader: @escaping () async throws -> [Team], selection: @escaping (Team) -> PlayerView) {
        self.teamLoader = teamLoader
        self.selection = selection
    }
    
    @MainActor
    func loadTeams() async {
        isLoading = true
        do {
            teams = try await teamLoader()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load teams: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

struct ErrorModel: Identifiable {
    let id = UUID()
    let message: String
}

final class MockTeamViewModel {
    static func mockTeamLoader() async throws -> [Team] {
        return [
            Team(id: "1", name: "LDU de Quito", logoURL: URL(string: "https://media.api-sports.io/football/teams/1158.png")!),
            Team(id: "1", name: "Aucas", logoURL: URL(string: "https://media.api-sports.io/football/teams/1156.png")!),
        ]
    }
}

