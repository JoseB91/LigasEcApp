//
//  LeagueViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

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
    }
    
    @MainActor
    func loadLeagues() async {
        isLoading = true
        do {
            leagues = try await leagueLoader()
        } catch {
            // Will never fail
        }
        isLoading = false
    }
}

final class MockLeagueViewModel {
    static func mockLeagueLoader() async throws -> [League] {
        let hardcodedLeagues = [
            League(id: "IaFDigtm",
                   name: "LigaPro Serie A",
                   logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!,
                   dataSource: .FlashLive),
            League(id: "EC2L",
                   name: "LigaPro Serie B",
                   logoURL: URL(string: "https://www.flashscore.com/res/image/data/2g15S2DO-GdicJTVi.png")!,
                   dataSource: .TransferMarket)
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

