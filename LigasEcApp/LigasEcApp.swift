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
                                   imageView: composer.composeImageView,
                                   title: team.name)
                    }
                    .task {
                        print("TASK")
                        try? await composer.validateCache()
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
        }
    }
}

//TODO: Add Acceptance and UIIntegration tests
//
//@State private var isTabBarVisible: Bool = true
//
//var body: some Scene {
//    WindowGroup {
//        ZStack {
//            TabView(selection: $selectedTab) {
//                LeagueTabView(
//                    leagueViewModel: leagueViewModel,
//                    isTabBarVisible: $isTabBarVisible
//                )
//                .tag(0)
//                .tabItem {
//                    Label("Ligas", systemImage: "soccerball")
//                }
//
//                SettingsTabView()
//                    .tag(1)
//                    .tabItem {
//                        Label("Settings", systemImage: "gear")
//                    }
//            }
//            .opacity(isTabBarVisible ? 1 : 0)
//            // O puedes usar `.offset(y: isTabBarVisible ? 0 : 200)`
//        }
//    }
//}
//struct TeamView: View {
//    @Binding var isTabBarVisible: Bool
//
//    var body: some View {
//        VStack {
//            Text("Team Details")
//        }
//        .onAppear {
//            isTabBarVisible = false
//        }
//        .onDisappear {
//            isTabBarVisible = true
//        }
//    }
//}
