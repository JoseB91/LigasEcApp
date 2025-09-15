//
//  PlayerViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 26/2/25.
//

import Foundation
import SwiftUI

@Observable
final class PlayerViewModel {

    var squad = [Player]()
    var isLoading = false
    var errorModel: ErrorModel? = nil

    private let repository: PlayerRepository
        
    init(repository: PlayerRepository) {
        self.repository = repository
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
