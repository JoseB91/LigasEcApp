//
//  TeamViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 25/2/25.
//

import Foundation

@Observable
final class TeamViewModel {

    var teams = [Team]()
    var isLoading = false
    var errorMessage: ErrorModel? = nil

    private let teamLoader: () async throws -> [Team]
        
    init(teamLoader: @escaping () async throws -> [Team]) {
        self.teamLoader = teamLoader
    }
    
    @MainActor
    func loadTeams() async {
        isLoading = true
        do {
            teams = try await teamLoader()
        } catch {
            errorMessage = ErrorModel(message: error.localizedDescription)
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
                     logoURL: URL(string: "https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png")!,
                     dataSource: .FlashLive),
                Team(id: "pCMG6CNq",
                             name: "Barcelona SC",
                             logoURL: URL(string: "https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png")!,
                             dataSource: .FlashLive)]
    }
}

