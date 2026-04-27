//
//  LeagueViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import Foundation

@Observable
final class LeagueViewModel {

    var leagues = [League]()
    var isLoading = false
    var errorMessage: ErrorModel? = nil
    
    private let repository: LeagueRepository
    private var hasLoaded = false
        
    init(repository: LeagueRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadLeagues() async {
        
        isLoading = true
        defer { isLoading = false }
        
        let result = await repository.loadLeagues()
        leagues = result.leagues
        errorMessage = result.errorModel
    }
    
    @MainActor
    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true

        await loadLeagues()
    }
}
