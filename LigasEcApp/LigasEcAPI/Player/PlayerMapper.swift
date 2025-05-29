//
//  PlayerMapper.swift
//  LigasEcAPI
//
//  Created by José Briones on 26/2/25.
//

import Foundation

public final class PlayerMapper {
        
    // MARK: - Root
    private struct RootFlashLive: Codable {
        let data: [Datum]
        
        var squad: [Player] {
            data.flatMap { group in
                group.items.compactMap { item in
                    Player(id: item.playerID,
                           name: item.playerName,
                           number: item.playerJerseyNumber,
                           position: item.playerTypeID.spanishName,
                           flagId: item.playerFlagID,
                           photoURL: item.playerImagePath,
                           dataSource: .FlashLive)
                }
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case data = "DATA"
        }
        
        struct Datum: Codable {
            let groupID: Int
            let groupLabel: String
            let items: [Item]

            enum CodingKeys: String, CodingKey {
                case groupID = "GROUP_ID"
                case groupLabel = "GROUP_LABEL"
                case items = "ITEMS"
            }
            
            struct Item: Codable {
                let playerID, playerName: String
                let playerTypeID: PlayerTypeID
                let playerJerseyNumber: Int?
                let playerFlagID: Int
                let playerImagePath: URL?

                enum CodingKeys: String, CodingKey {
                    case playerID = "PLAYER_ID"
                    case playerName = "PLAYER_NAME"
                    case playerTypeID = "PLAYER_TYPE_ID"
                    case playerJerseyNumber = "PLAYER_JERSEY_NUMBER"
                    case playerFlagID = "PLAYER_FLAG_ID"
                    case playerImagePath = "PLAYER_IMAGE_PATH"
                }
            }
            
            enum PlayerTypeID: String, Codable {
                case coach = "COACH"
                case defender = "DEFENDER"
                case forward = "FORWARD"
                case goalkeeper = "GOALKEEPER"
                case midfielder = "MIDFIELDER"
                
                var spanishName: String {
                    switch self {
                    case .coach:
                        return "Entrenador"
                    case .defender:
                        return "Defensa"
                    case .forward:
                        return "Delantero"
                    case .goalkeeper:
                        return "Portero"
                    case .midfielder:
                        return "Centrocampista"
                    }
                }
            }
        }
    }
            
    private struct RootTransferMarket: Codable {
        let squadCodable: [SquadCodable]
        
        enum CodingKeys: String, CodingKey {
            case squadCodable = "squad"
        }

        var squad: [Player] {
            squadCodable.compactMap {  Player(id: $0.id,
                                              name: $0.name,
                                              number: $0.shirtNumber != nil ? Int($0.shirtNumber!) : nil,
                                              position: $0.positions?.first?.group ?? "",
                                              nationality: $0.nationalities.first?.name,
                                              photoURL: $0.image,
                                              dataSource: .TransferMarket)
                }
        }

        // MARK: - Squad
        struct SquadCodable: Codable {
            let id, name: String
            let image: URL
            let shirtNumber: String?
            let positions: Positions?
            let nationalities: [Nationality]
        }
        
        struct Positions: Codable {
            let first, second, third: Position?
        }
        
        struct Position: Codable {
            let id, name, shortName, group: String
        }
        
        struct Nationality: Codable {
            let id: Int
            let name: String
            let imageURL: URL?
        }

    }
    public static func map(_ data: Data, from response: HTTPURLResponse, with source: DataSource) throws -> [Player] {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            if source == .FlashLive {
                let root = try JSONDecoder().decode(RootFlashLive.self, from: data)
                return root.squad
            } else {
                let root = try JSONDecoder().decode(RootTransferMarket.self, from: data)
                return root.squad
            }
        } catch {
            throw error
        }
    }
}

public struct Player: Hashable, Identifiable {
    public let id: String
    public let name: String
    public let number: Int?
    public let position: String
    public let flagId: Int?
    public let nationality: String?
    public let photoURL: URL?
    public let dataSource: DataSource
    
    public init(id: String, name: String, number: Int?, position: String, flagId: Int? = nil, nationality: String? = nil, photoURL: URL?, dataSource: DataSource) {
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
