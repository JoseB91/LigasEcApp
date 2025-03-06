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
        League(id: "IaFDigtm",
               stageId: "OO37de6i",
               name: "Liga Pro",
               logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!),
        League(id: "0O4IjDeg",
               stageId: "Au6JggjA",
               name: "Serie B",
               logoURL: URL(string: "https://www.flashscore.com/res/image/data/2g15S2DO-GdicJTVi.png")!)
    ]
    
    let selection: (League) -> TeamView
    
    var title: String {
        String(localized: "LEAGUE_VIEW_TITLE",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }
    
    init(selection: @escaping (League) -> TeamView) {
        self.selection = selection
    }
}

