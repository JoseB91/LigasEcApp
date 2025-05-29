//
//  TeamEndpoint.swift
//  LigasEcAPI
//
//  Created by José Briones on 25/2/25.
//

import Foundation

public enum TeamEndpoint {
    case getFlashLive(seasonId: String, standingType: String, locale: String, tournamentStageId: String)
    case getTransferMarket(id: String, domain: String)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .getFlashLive(seasonId, standingType, locale, tournamentStageId):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/tournaments/standings"
            components.queryItems = [
                URLQueryItem(name: "tournament_season_id", value: "\(seasonId)"),
                URLQueryItem(name: "standing_type", value: "\(standingType)"),
                URLQueryItem(name: "locale", value: "\(locale)"),
                URLQueryItem(name: "tournament_stage_id", value: "\(tournamentStageId)")

            ].compactMap { $0 }
            return components.url!
        case let .getTransferMarket(id, domain):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "clubs/list-by-competition/"
            components.queryItems = [
                URLQueryItem(name: "id", value: "\(id)"),
                URLQueryItem(name: "domain", value: "\(domain)")

            ].compactMap { $0 }
            return components.url!
        }
    }
}
