//
//  LeagueViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import Foundation

@Observable
final class LeagueViewModel {

    var leagues = [League]()
    var isLoading = false
    var errorMessage: ErrorModel? = nil
    
    private let repository: LeagueRepository
        
    var title: String {
        String(localized: "LEAGUE_VIEW_TITLE",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }
    
    init(repository: LeagueRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadLeagues() async {
        
        isLoading = true
        defer { isLoading = false }
        
        leagues = await repository.loadLeagues()
    }
}

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
