//
//  PlayerViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 26/2/25.
//

import Foundation
import SwiftUICore

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

struct Constants {
    
    static var ligasEc: LocalizedStringKey { "LIGAS_EC" }
    static var settings: LocalizedStringKey { "SETTINGS" }
    
    //Error
    static let ok = "OK"
    static let error = "Error"
    
    //Players
    static var coach: LocalizedStringKey { "COACH" }
    static var goalkeeper: LocalizedStringKey { "GOALKEEPER" }
    static var defender: LocalizedStringKey { "DEFENDER" }
    static var midfielder: LocalizedStringKey { "MIDFIELDER" }
    static var forward: LocalizedStringKey { "FORWARD" }
    
    static let portero = "Portero"
    static let defensa = "Defensa"
    static let centrocampista = "Centrocampista"
    static let delantero = "Delantero"
    static let entrenador = "Entrenador"
}
