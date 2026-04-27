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
                           position: item.playerTypeID.position,
                           flagId: item.playerFlagID,
                           photoURL: item.playerImagePath,
                           dataSource: .flashLive)
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
                
                var position: Player.Position {
                    switch self {
                    case .coach:
                        return .coach
                    case .defender:
                        return .defender
                    case .forward:
                        return .forward
                    case .goalkeeper:
                        return .goalkeeper
                    case .midfielder:
                        return .midfielder
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
                                              position: .init(storageValue: $0.positions?.first?.group ?? ""),
                                              nationality: $0.nationalities.first?.name,
                                              photoURL: $0.image,
                                              dataSource: .transferMarket)
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
            if source == .flashLive {
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
