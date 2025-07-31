//
//  MockLeague.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

struct MockLeagueViewModel {
    static func mockLeagues() -> [League] {
        let hardcodedLeagues = [
            League(id: "IaFDigtm",
                   name: "LigaPro Serie A",
                   logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!,
                   dataSource: .flashLive),
            League(id: "EC2L",
                   name: "LigaPro Serie B",
                   logoURL: URL(string: "https://www.flashscore.com/res/image/data/2g15S2DO-GdicJTVi.png")!,
                   dataSource: .transferMarket)
        ]
        
        return hardcodedLeagues
    }
}

struct MockLeagueRepository: LeagueRepository {
    func loadLeagues() async -> [League] {
        MockLeagueViewModel.mockLeagues()
    }
}
