//
//  PlayerDetailEndpoint.swift
//  LigasEcApp
//
//  Created by José Briones on 8/7/26.
//

//GET https://flashlive-sports.p.rapidapi.com/v1/players/data?player_id=vgOOdZbd&sport_id=1&locale=en_INT


import Foundation

public enum PlayerDetailEndpoint {
    case getFlashLive(playerId: String, sportId: Int, locale: String)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .getFlashLive(playerId, sportId, locale):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/players" + "/data"
            components.queryItems = [
                URLQueryItem(name: "player_id", value: "\(playerId)"),
                URLQueryItem(name: "sport_id", value: "\(sportId)"),
                URLQueryItem(name: "locale", value: locale),
            ].compactMap { $0 }
            
            guard let url = components.url else { return baseURL }
            return url
        }
    }
}
