//
//  PlayerViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 26/2/25.
//

import Foundation
import SwiftUI

final class PlayerViewModel: ObservableObject {

    @Published var squad = [Player]()
    @Published var isLoading = false
    @Published var errorModel: ErrorModel? = nil

    private let repository: PlayerRepository
    private var hasLoaded = false
        
    init(repository: PlayerRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        await loadSquad()
    }
    
    @MainActor
    func loadSquad() async {
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            squad = try await repository.loadPlayers()
        } catch {
            errorModel = ErrorModel(message: error.localizedDescription)
        }
    }
}
