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

    private let repository: TeamRepository
    
    init(repository: TeamRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadTeams() async {
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            teams = try await repository.loadTeams()
        } catch {
            errorMessage = ErrorModel(message: error.localizedDescription)
        }
    }
}

struct ErrorModel: Identifiable {
    let id = UUID()
    let message: String
}

struct MockTeamViewModel {
    static func mockTeams() -> [Team] {
        return [Team(id: "pCMG6CNp",
                     name: "Barcelona SC",
                     logoURL: URL(string: "https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png")!,
                     dataSource: .flashLive),
                Team(id: "pCMG6CNq",
                             name: "Barcelona SC",
                             logoURL: URL(string: "https://www.flashscore.com/res/image/data/nit9vJwS-WErjuywa.png")!,
                             dataSource: .flashLive)]
    }
}

struct MockTeamRepository: TeamRepository {
    func loadTeams() async throws -> [Team] {
        MockTeamViewModel.mockTeams()
    }
}
