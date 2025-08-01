//
//  LigasEcApp.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import SwiftUI

@main
struct LigasEcApp: App {
    
    private let composer = Composer.makeComposer()
    @State var navigationPath = NavigationPath()
    @State private var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                NavigationStack(path: $navigationPath) {
                    LeagueView(leagueViewModel: composer.composeLeagueViewModel(),
                               navigationPath: $navigationPath,
                               imageViewLoader: composer.composeImageView)
                    .navigationDestination(for: League.self) { league in
                        TeamView(teamViewModel: composer.composeTeamViewModel(for: league),
                                 navigationPath: $navigationPath,
                                 imageViewLoader: composer.composeImageView,
                                 title: league.name)
                    }
                    .navigationDestination(for: Team.self) { team in
                        PlayerView(playerViewModel: composer.composePlayerViewModel(for: team),
                                   imageViewLoader: composer.composeImageView,
                                   title: team.name)
                    }
                    .task {
                        try? await composer.validateCache()
                    }
                }
                .tabItem { Label(Constants.ligasEc, systemImage: "soccerball") }
                .tag(0)
                
                NavigationStack() {
                    SettingsView()
                }
                .tabItem { Label(Constants.settings, systemImage: "gear") }
                .tag(1)
            }
        }
    }
}

//TODO: Add Acceptance and UIIntegration tests
