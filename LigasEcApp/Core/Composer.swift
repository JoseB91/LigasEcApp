//
//  Composer.swift
//  LigasEcApp
//
//  Created by José Briones on 10/3/25.
//

import CoreData
import os

class Composer {
    private let flashLiveEndpointConfiguration: EndpointConfiguration
    private let transferMarketEndpointConfiguration: EndpointConfiguration
    private let httpClient: URLSessionHTTPClient
    private let appLocalLoader: AppLocalLoader
    private let teamRemoteLoaders: TeamRemoteLoaders
    private let playerRemoteLoaders: PlayerRemoteLoaders

    init(flashLiveEndpointConfiguration: EndpointConfiguration,
         transferMarketEndpointConfiguration: EndpointConfiguration,
         httpClient: URLSessionHTTPClient,
         appLocalLoader: AppLocalLoader,
         teamRemoteLoaders: TeamRemoteLoaders,
         playerRemoteLoaders: PlayerRemoteLoaders) {
        self.flashLiveEndpointConfiguration = flashLiveEndpointConfiguration
        self.transferMarketEndpointConfiguration = transferMarketEndpointConfiguration
        self.httpClient = httpClient
        self.appLocalLoader = appLocalLoader
        self.teamRemoteLoaders = teamRemoteLoaders
        self.playerRemoteLoaders = playerRemoteLoaders
    }
    
    static func makeComposer() -> Composer {
        
        guard
            let flashLiveConfig = EndpointConfiguration.makeFlashLive(),
            let transferMarketConfig = EndpointConfiguration.makeTransferMarket()
        else {
            fatalError("Missing endpoint configuration values. Verify Config.xcconfig/Info.plist settings.")
        }
        
        let httpClient = makeHTTPClient()
        
        let store = makeStore()
        
        let localLeagueLoader = LocalLeagueLoader(store: store, currentDate: Date.init)
        let localTeamLoader = LocalTeamLoader(store: store, currentDate: Date.init)
        let localPlayerLoader = LocalPlayerLoader(store: store, currentDate: Date.init)
        let localImageLoader = LocalImageLoader(store: store)

        let appLocalLoader = AppLocalLoader(localLeagueLoader: localLeagueLoader,
                                            localTeamLoader: localTeamLoader,
                                            localPlayerLoader: localPlayerLoader,
                                            localImageLoader: localImageLoader)

        let teamRemoteLoaders = TeamRemoteLoaders(loaders: [
            .flashLive: FlashLiveTeamRemoteLoader(
                httpClient: httpClient,
                configuration: flashLiveConfig
            ),
            .transferMarket: TransferMarketTeamRemoteLoader(
                httpClient: httpClient,
                configuration: transferMarketConfig
            )
        ])
        
        let playerRemoteLoaders = PlayerRemoteLoaders(loaders: [
            .flashLive: FlashLivePlayerRemoteLoader(
                httpClient: httpClient,
                configuration: flashLiveConfig
            ),
            .transferMarket: TransferMarketPlayerRemoteLoader(
                httpClient: httpClient,
                configuration: transferMarketConfig
            )
        ])
        
        return Composer(flashLiveEndpointConfiguration: flashLiveConfig,
                        transferMarketEndpointConfiguration: transferMarketConfig,
                        httpClient: httpClient,
                        appLocalLoader: appLocalLoader,
                        teamRemoteLoaders: teamRemoteLoaders,
                        playerRemoteLoaders: playerRemoteLoaders)
    }
    
    private static func makeHTTPClient() -> URLSessionHTTPClient {
        guard let apiKey = retrieveAPIKey(), !apiKey.isEmpty else {
            fatalError("No RapidAPI key configured. Set API_KEY in Config.xcconfig or the keychain.")
        }
        
        return URLSessionHTTPClient(
            session: URLSession(configuration: .ephemeral),
            apiKey: apiKey)
    }

    private static func retrieveAPIKey() -> String? {
        do {
            return try KeychainManager.retrieveAPIKey()
        } catch KeychainError.itemNotFound {
            if let envAPIKey = ProcessInfo.processInfo.environment["API_KEY"], !envAPIKey.isEmpty {
                try? KeychainManager.saveAPIKey(envAPIKey)
                return envAPIKey
            }
            if let bundleAPIKey = Bundle.main.infoDictionary?["API_KEY"] as? String,
               !bundleAPIKey.isEmpty {
                try? KeychainManager.saveAPIKey(bundleAPIKey)
                return bundleAPIKey
            }
            Logger.composer.error("No API key found in Keychain, environment, or Info.plist")
            return nil
        } catch {
            Logger.composer.error("Error retrieving API key : \(error.localizedDescription)")
            return nil
        }
    }
    
    private static func makeStore() -> LeagueStore & ImageStore & TeamStore & PlayerStore {
        do {
            return try CoreDataLigasEcStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("ligas-ec-store.sqlite"))
        } catch {
            // Add logger
            return InMemoryStore()
        }
    }
    
    func composeLeagueViewModel() -> LeagueViewModel {
        let repository = LeagueRepositoryImpl(httpClient: httpClient,
                                              appLocalLoader: appLocalLoader)
        return LeagueViewModel(repository: repository)
    }
    
    func composeTeamViewModel(for league: League) -> TeamViewModel {
        let repository = TeamRepositoryImpl(appLocalLoader: appLocalLoader,
                                            league: league,
                                            remoteLoaders: teamRemoteLoaders)
        return TeamViewModel(repository: repository, league: league)
    }
    
    func composePlayerViewModel(for team: Team) -> PlayerViewModel {
        let repository = PlayerRepositoryImpl(appLocalLoader: appLocalLoader,
                                              team: team,
                                              remoteLoaders: playerRemoteLoaders)
        
        return PlayerViewModel(repository: repository)
    }
    
    func composeImageView(with url: URL, on table: Table) -> ImageView {
        let repository = ImageRepositoryImpl(url: url,
                                             table: table,
                                             httpClient: httpClient,
                                             appLocalLoader: appLocalLoader)

        let imageViewModel = ImageViewModel(repository: repository)

        return ImageView(imageViewModel: imageViewModel)
    }
    
    func validateCache() async throws {
        try await appLocalLoader.localLeagueLoader.validateCache()
    }
}

struct EndpointConfiguration {
    let url: URL
    let host: String
    let locale: String?
    let tournamentStageId: String?
    let standingType: String?
    let sportId: Int?
    let domain: String?
    
    static func makeFlashLive(bundle: Bundle = .main) -> EndpointConfiguration? {
        guard
            let baseURLString = bundle.infoValue(for: "FLASHLIVE_BASE_URL"),
            let host = bundle.infoValue(for: "FLASHLIVE_HOST"),
            let locale = bundle.infoValue(for: "FLASHLIVE_LOCALE"),
            let standingType = bundle.infoValue(for: "FLASHLIVE_STANDING_TYPE"),
            let tournamentStageId = bundle.infoValue(for: "FLASHLIVE_TOURNAMENT_STAGE_ID"),
            let sportIdString = bundle.infoValue(for: "FLASHLIVE_SPORT_ID"),
            let sportId = Int(sportIdString),
            let url = validURL(from: baseURLString, expectedHost: host)
        else {
            Logger.composer.error("Missing FlashLive configuration values")
            return nil
        }
        
        return EndpointConfiguration(
            url: url,
            host: host,
            locale: locale,
            tournamentStageId: tournamentStageId,
            standingType: standingType,
            sportId: sportId,
            domain: nil
        )
    }
    
    static func makeTransferMarket(bundle: Bundle = .main) -> EndpointConfiguration? {
        guard
            let baseURLString = bundle.infoValue(for: "TRANSFERMARKET_BASE_URL"),
            let host = bundle.infoValue(for: "TRANSFERMARKET_HOST"),
            let domain = bundle.infoValue(for: "TRANSFERMARKET_DOMAIN"),
            let url = validURL(from: baseURLString, expectedHost: host)
        else {
            Logger.composer.error("Missing TransferMarket configuration values")
            return nil
        }
        
        return EndpointConfiguration(
            url: url,
            host: host,
            locale: nil,
            tournamentStageId: nil,
            standingType: nil,
            sportId: nil,
            domain: domain
        )
    }

    private static func validURL(from baseURLString: String, expectedHost: String) -> URL? {
        guard
            let url = URL(string: baseURLString),
            let host = url.host,
            !host.isEmpty
        else {
            Logger.composer.error("Invalid endpoint base URL: \(baseURLString, privacy: .public)")
            return nil
        }

        guard host == expectedHost else {
            Logger.composer.error("Endpoint host mismatch. Expected \(expectedHost, privacy: .public), got \(host, privacy: .public)")
            return nil
        }

        return url
    }
}

private extension Bundle {
    func infoValue(for key: String) -> String? {
        infoDictionary?[key] as? String
    }
}

struct AppLocalLoader {
    let localLeagueLoader: LocalLeagueLoader
    let localTeamLoader: LocalTeamLoader
    let localPlayerLoader: LocalPlayerLoader
    let localImageLoader: LocalImageLoader
}

extension Logger {
    static let composer = Logger(subsystem: "com.joseB91.LatinCoaches", category: "Composer")
}
