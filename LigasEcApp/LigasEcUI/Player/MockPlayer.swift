//
//  MockPlayer.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

struct MockPlayerViewModel {
    static func mockPlayers() -> [Player] {
        return [Player(id: "S0nWKdXm",
                       name: "Contreras José",
                       number: 1,
                       position: "Portero",
                       nationality: "Venezuela",
                       photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
                       dataSource: .flashLive),
                Player(id: "S0nWKdXn",
                       name: "Contreras José",
                       number: 1,
                       position: "Portero",
                       nationality: "Venezuela",
                       photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
                       dataSource: .flashLive)]
    }
    
    static func mockPlayer() -> Player {
        return Player(id: "S0nWKdXm",
                      name: "Contreras José",
                      number: 1,
                      position: "Portero",
                      photoURL: URL(string: "https://www.flashscore.com/res/image/data/WKTYkjyS-nFdH6Slk.png")!,
                      dataSource: .flashLive)
    }
}

struct MockPlayerRepository: PlayerRepository {
    func loadPlayers() async throws -> [Player] {
        MockPlayerViewModel.mockPlayers()
    }
}
