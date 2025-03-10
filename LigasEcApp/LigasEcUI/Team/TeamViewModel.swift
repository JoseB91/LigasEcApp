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

    private let teamLoader: () async throws -> [Team]
    
    var title: String {
        String(localized: "TEAM_VIEW_TITLE",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }
    
    init(teamLoader: @escaping () async throws -> [Team]) {
        self.teamLoader = teamLoader
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
        return [Team(id: "pCMG6CNp",
                     name: "Barcelona SC",
                     logoURL: URL(string: "https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png")!)]
    }
}

