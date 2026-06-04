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
    var isSerieBComingSoon = false

    @ObservationIgnored private let repository: TeamRepository
    @ObservationIgnored private let league: League
    @ObservationIgnored private var hasLoaded = false
    
    init(repository: TeamRepository, league: League) {
        self.repository = repository
        self.league = league
    }
    
    @MainActor
    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        await loadTeams()
    }
    
    @MainActor
    func loadTeams() async {
        
        let isFeatureEnabled = FeatureFlags.isEnabled(for: league)
        isSerieBComingSoon = !isFeatureEnabled
        guard isFeatureEnabled else {
            teams = []
            errorModel = nil
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            teams = try await repository.loadTeams()
        } catch {
            errorModel = ErrorModel(message: error.localizedDescription)
        }
    }
}
