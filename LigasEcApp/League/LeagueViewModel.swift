//
//  LeagueViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import LigasEcAPI
import SharedAPI

final class LeagueViewModel {

    let leagues = [
        League(id: 240,
               seasonId: 71184,
               name: "LigaPro Serie A",
               logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!),
        League(id: 10240,
               seasonId: 72724,
               name: "LigaPro Serie B",
               logoURL: URL(string: "https://www.flashscore.com/res/image/data/2g15S2DO-GdicJTVi.png")!)
    ]
        
    var title: String {
        String(localized: "LEAGUE_VIEW_TITLE",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }
}

