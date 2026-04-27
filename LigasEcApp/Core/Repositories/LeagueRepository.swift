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
    private let bootstrapLeagues: [League]

    init(httpClient: HTTPClient, appLocalLoader: AppLocalLoader, bootstrapLeagues: [League]) {
        self.httpClient = httpClient
        self.appLocalLoader = appLocalLoader
        self.bootstrapLeagues = bootstrapLeagues
    }
    
    func loadLeagues() async -> LeagueLoadResult {
        
        do {
            return LeagueLoadResult(leagues: try await appLocalLoader.localLeagueLoader.load(),
                                    errorModel: nil)
        } catch {
            try? await appLocalLoader.localLeagueLoader.save(bootstrapLeagues)
            
            let errorModel: ErrorModel?
            if case LocalLeagueLoaderError.emptyData = error {
                errorModel = nil
            } else {
                errorModel = ErrorModel(message: error.localizedDescription)
            }
            
            return LeagueLoadResult(leagues: bootstrapLeagues,
                                    errorModel: errorModel)
        }
    }
}
