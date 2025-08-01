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
    var errorModel: ErrorModel? = nil

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
            errorModel = ErrorModel(message: error.localizedDescription)
        }
    }
}
