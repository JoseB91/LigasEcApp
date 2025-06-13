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
        
    @State private var navigationPath = NavigationPath()
    @State private var selectedTab = 0

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                NavigationStack(path: $navigationPath) {
                    LeagueView(leagueViewModel: composer.composeLeagueViewModel(),
                               navigationPath: $navigationPath,
                               imageView: composer.composeImageView)
                    .navigationDestination(for: League.self) { league in
                        TeamView(teamViewModel: composer.composeTeamViewModel(for: league),
                                 navigationPath: $navigationPath,
                                 imageView: composer.composeImageView,
                                 title: league.name)
                        .toolbar(.hidden, for: .tabBar)
                    }
                    .navigationDestination(for: Team.self) { team in
                        PlayerView(playerViewModel: composer.composePlayerViewModel(for: team),
                                   imageView: composer.composeImageView,
                                   title: team.name)
                    }
                }
                .tabItem {
                    Label("LigasEc", systemImage: "soccerball")
                }
                .tag(0)
                
                NavigationStack() {
                    SettingsView()
                }
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(1)
            }
            .task {
                try? await composer.validateCache()
            }
        }
    }
    
}

//TODO: Add Acceptance and UIIntegration tests
