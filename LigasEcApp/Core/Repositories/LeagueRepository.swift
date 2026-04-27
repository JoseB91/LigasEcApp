//
//  LeagueRepository.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

struct LeagueLoadResult {
    let leagues: [League]
    let errorModel: ErrorModel?
}

protocol LeagueRepository {
    func loadLeagues() async -> LeagueLoadResult
}

final class LeagueRepositoryImpl: LeagueRepository {
    private let httpClient: HTTPClient
    private let appLocalLoader: AppLocalLoader

    init(httpClient: HTTPClient, appLocalLoader: AppLocalLoader) {
        self.httpClient = httpClient
        self.appLocalLoader = appLocalLoader
    }
    
    func loadLeagues() async -> LeagueLoadResult {
        
        do {
            return LeagueLoadResult(leagues: try await appLocalLoader.localLeagueLoader.load(),
                                    errorModel: nil)
        } catch {
            let hardcodedLeagues = [
                League(id: "trd6vSd3",
                       name: "LigaPro Serie A",
                       logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!,
                       dataSource: .flashLive),
                League(id: "EC2L",
                       name: "LigaPro Serie B",
                       logoURL: URL(string: "https://www.flashscore.com/res/image/data/2g15S2DO-GdicJTVi.png")!,
                       dataSource: .transferMarket)
            ]
            
            try? await appLocalLoader.localLeagueLoader.save(hardcodedLeagues)
            
            return LeagueLoadResult(leagues: hardcodedLeagues,
                                    errorModel: ErrorModel(message: error.localizedDescription))
        }
    }
}
