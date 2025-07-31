//
//  MockTeam.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

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
