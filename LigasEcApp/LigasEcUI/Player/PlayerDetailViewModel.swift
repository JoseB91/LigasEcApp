//
//  PlayerDetailViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 8/7/26.
//

import Foundation

@Observable
final class PlayerDetailViewModel {

    @ObservationIgnored private let player: Player

    init(player: Player) {
        self.player = player
    }

    var name: String {
        player.name
    }

    var number: Int? {
        player.number
    }

    var nationality: String? {
        player.nationality
    }

    var photoURL: URL? {
        player.photoURL
    }

    // Prefers the explicit flagId; falls back to resolving it from the nationality name
    var flagId: Int? {
        if let flagId = player.flagId {
            return flagId
        }
        if let nationality = player.nationality {
            return nationality.getPlayerCountryId()
        }
        return nil
    }
}
