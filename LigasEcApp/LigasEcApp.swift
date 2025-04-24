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
                LeagueView(leagueViewModel: composer.composeLeagueViewModel(),
                           navigationPath: $navigationPath,
                           imageView: composer.composeImageView)
                    .navigationDestination(for: League.self) { league in
                        TeamView(teamViewModel: composer.composeTeamViewModel(for: league),
                                 navigationPath: $navigationPath,
                                 imageView: composer.composeImageView,
                                 title: league.name)
                        .navigationBarBackButtonHidden(true)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    navigationPath.removeLast()
                                } label: {
                                    HStack(spacing: 5) {
                                        Image(systemName: "chevron.left")
                                        Text("LigasEc")
                                            .fontWeight(.regular)
                                    }
                                }
                            }
                        }
                    }
                    .navigationDestination(for: Team.self) { team in
                        PlayerView(playerViewModel: composer.composePlayerViewModel(for: team),
                                   imageView: composer.composeImageView,
                                   title: team.name)
                    }
            }
            .task {
                do {
                    try await composer.validateCache()
                } catch {
                    print(error)
                }
            }
        }
    }
    
}

//TODO: Add Acceptance and UIIntegration tests
