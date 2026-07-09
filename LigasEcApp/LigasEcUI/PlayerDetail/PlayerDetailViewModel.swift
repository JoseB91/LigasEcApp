//
//  PlayerDetailViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 8/7/26.
//

import Foundation

@Observable
final class PlayerDetailViewModel {

    var playerDetail = PlayerDetail.empty
    var isLoading = false
    var errorModel: ErrorModel? = nil

    @ObservationIgnored private let repository: PlayerDetailRepository
    @ObservationIgnored private var hasLoaded = false

    init(repository: PlayerDetailRepository) {
        self.repository = repository
    }
    
//    @MainActor
//    func loadIfNeeded() async {
//        guard !hasLoaded else { return }
//        hasLoaded = true
//        await loadPlayerDetail()
//    }

    @MainActor
    func loadPlayerDetail() async {
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            playerDetail = try await repository.loadPlayerDetail()
        } catch {
            errorModel = ErrorModel(message: error.localizedDescription)
        }
    }
    
    // Prefers the explicit flagId; falls back to resolving it from the nationality name
    var flagId: Int? {
        if let countryName = playerDetail.countryName {
            return countryName.getPlayerCountryId()
        }
        return nil
    }
}
