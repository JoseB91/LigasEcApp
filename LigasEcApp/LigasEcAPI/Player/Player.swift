//
//  Player.swift
//  LigasEcApp
//
//  Created by José Briones on 30/7/25.
//

import Foundation

public struct Player: Hashable, Identifiable {
    public enum Position: Hashable {
        case goalkeeper
        case defender
        case midfielder
        case forward
        case coach
        case unknown(String)

        public init(storageValue: String) {
            switch storageValue.lowercased() {
            case "goalkeeper", "portero":
                self = .goalkeeper
            case "defender", "defensa":
                self = .defender
            case "midfielder", "centrocampista":
                self = .midfielder
            case "forward", "delantero":
                self = .forward
            case "coach", "entrenador":
                self = .coach
            default:
                self = .unknown(storageValue)
            }
        }

        public var storageValue: String {
            switch self {
            case .goalkeeper:
                return "Portero"
            case .defender:
                return "Defensa"
            case .midfielder:
                return "Centrocampista"
            case .forward:
                return "Delantero"
            case .coach:
                return "Entrenador"
            case let .unknown(value):
                return value
            }
        }
    }

    public let id: String
    public let name: String
    public let number: Int?
    public let position: Position
    public let flagId: Int?
    public let nationality: String?
    public let photoURL: URL?
    public let dataSource: DataSource
    
    public init(id: String, name: String, number: Int?, position: Position, flagId: Int? = nil, nationality: String? = nil, photoURL: URL?, dataSource: DataSource) {
        self.id = id
        self.name = name
        self.number = number
        self.position = position
        self.flagId = flagId
        self.nationality = nationality
        self.photoURL = photoURL
        self.dataSource = dataSource
    }
}
