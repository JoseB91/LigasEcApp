//
//  LeagueViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import Foundation
import Combine
import LigasEcAPI
import SharedAPI

final class LeagueViewModel: ObservableObject {

    @Published var leagues = [League]()
    @Published var isLoading = false
    @Published var errorMessage: ErrorModel? = nil

    private let leagueLoader: () async throws -> [League]
    
    var title: String {
        String(localized: "LEAGUE_VIEW_TITLE",
               table: "League",
               bundle: Bundle(for: Self.self))
    }
    
    init(leagueLoader: @escaping () async throws -> [League]) {
        self.leagueLoader = leagueLoader
    }
    
    @MainActor
    func loadLeagues() async {
        isLoading = true
        do {
            leagues = try await leagueLoader()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load leagues: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

struct ErrorModel: Identifiable {
    let id = UUID()
    let message: String
}
