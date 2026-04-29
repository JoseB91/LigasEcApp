//
//  Enums.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

public enum DataSource: String, Codable, Sendable {
    case flashLive
    case transferMarket
}

public enum Table: Sendable {
    case league
    case team
    case player
}
