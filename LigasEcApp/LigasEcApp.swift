//
//  LigasEcApp.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import SwiftUI
import Combine
import LigasEcAPI
import SharedAPI
import Security
import CoreData
import os

@main
struct LigasEcApp: App {
    private let composer: Composer
    
    init() {
        self.composer = Composer.makeComposer()
    }
    
    @State private var navigationPath = NavigationPath()
        
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                LeagueView(leagueViewModel: LeagueViewModel(), navigationPath: $navigationPath)
                    .navigationDestination(for: League.self) { league in
                        TeamView(teamViewModel: composer.composeTeamViewModel(for: league), navigationPath: $navigationPath)
                    }
                    .navigationDestination(for: Team.self) { team in
                        PlayerView(playerViewModel: composer.composePlayerViewModel(for: team))
                    }
            }
        }
    }
    
}

//TODO: Add Acceptance and UIIntegration tests

