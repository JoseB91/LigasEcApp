//
//  LeagueViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import LigasEcAPI
import SharedAPI
import UIKit

final class LeagueViewModel: ObservableObject {

    @Published var leagues = [League]()
    @Published var isLoading = false
    @Published var errorMessage: ErrorModel? = nil
    
    private let leagueLoader: () async throws -> [League]
        
    var title: String {
        String(localized: "LEAGUE_VIEW_TITLE",
               table: "LigasEc",
               bundle: Bundle(for: Self.self))
    }
    
    init(leagueLoader: @escaping () async throws -> [League]) {
        self.leagueLoader = leagueLoader
        let libraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
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

final class MockLeagueViewModel {
    static func mockLeagueLoader() async throws -> [League] {
        let hardcodedLeagues = [
            League(id: "IaFDigtm",
                   stageId: "OO37de6i",
                   name: "LigaPro Serie A",
                   logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!),
            League(id: "0O4IjDeg",
                   stageId: "Au6JggjA",
                   name: "LigaPro Serie B",
                   logoURL: URL(string: "https://www.flashscore.com/res/image/data/2g15S2DO-GdicJTVi.png")!)
        ]
        
        return hardcodedLeagues
    }
}

final class MockImageView {
    static func mockImageView(url: URL, table: Table) -> ImageView {
        
        let imageLoader = {
            Data()
        }
        return ImageView(imageViewModel: ImageViewModel(imageLoader: imageLoader,
                                                        imageTransformer: UIImage.init))
    }
}

