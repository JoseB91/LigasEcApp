//
//  LeagueRepository.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

protocol LeagueRepository {
    func loadLeagues() async -> [League]
}

final class LeagueRepositoryImpl: LeagueRepository {
    private let httpClient: HTTPClient
    private let appLocalLoader: AppLocalLoader

    init(httpClient: HTTPClient, appLocalLoader: AppLocalLoader) {
        self.httpClient = httpClient
        self.appLocalLoader = appLocalLoader
    }
    
    func loadLeagues() async -> [League] {
        let hardcodedLeagues = [
            League(id: "IaFDigtm",
                   name: "LigaPro Serie A",
                   logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!,
                   dataSource: .FlashLive),
            League(id: "EC2L",
                   name: "LigaPro Serie B",
                   logoURL: URL(string: "https://www.flashscore.com/res/image/data/2g15S2DO-GdicJTVi.png")!,
                   dataSource: .TransferMarket)
        ]
        
        try? await appLocalLoader.localLeagueLoader.save(hardcodedLeagues)
        
        return hardcodedLeagues
    }
}
