//
//  Extensions.swift
//  LigasEcApp
//
//  Created by José Briones on 31/7/25.
//

import SwiftUICore

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

extension String {
    func getPlayerCountryId() -> Int {
        switch self {
        case "Argentina":
            return 22
        case "Brasil":
            return 39
        case "Colombia":
            return 53
        case "Ecuador":
            return 68
        case "Nigeria":
            return 143
        case "Paraguay":
            return 151
        case "Uruguay":
            return 201
        case "Venezuela":
            return 205
        default:
            return 0
        }
    }
    
    func getPlayerLocalizedPosition() -> LocalizedStringKey {
        switch self {
        case "Portero":
            return Constants.goalkeeper
        case "Defensa":
            return Constants.defender
        case "Centrocampista":
            return Constants.midfielder
        case "Delantero":
            return Constants.forward
        case "Entrenador":
            return Constants.coach
        default:
            return ""
        }
    }
}
