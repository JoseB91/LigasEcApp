//
//  PlayerEndpoint.swift
//  LigasEcAPI
//
//  Created by José Briones on 26/2/25.
//

import Foundation

public enum PlayerEndpoint {
    case getFlashLive(sportId: Int, locale: String, teamId: String)
    case getTransferMarket(id: String, domain: String)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .getFlashLive(sportId, locale, teamId):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/teams" + "/squad"
            components.queryItems = [
                URLQueryItem(name: "sport_id", value: "\(sportId)"),
                URLQueryItem(name: "locale", value: "\(locale)"),
                URLQueryItem(name: "team_id", value: "\(teamId)")
            ].compactMap { $0 }
            return components.url!
            
        case let .getTransferMarket(id, domain):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "clubs/get-squad"
            components.queryItems = [
                URLQueryItem(name: "id", value: "\(id)"),
                URLQueryItem(name: "domain", value: "\(domain)")
            ].compactMap { $0 }
            return components.url!
        }
    }
}
